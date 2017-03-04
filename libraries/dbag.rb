module Dbag
  class KeyStore

    def initialize(data_bag, data_bag_item)
      @data_bag = data_bag
      @data_bag_item = data_bag_item
    end

    def data_bag
      Chef::EncryptedDataBagItem.load(@data_bag, @data_bag_item)
    rescue
      {
        "id" => @data_bag_item
      }
    end

    def get(key)
      data_bag[key]
    end

    def put(key, value)
      update(data_bag.to_hash.merge({
        key => value
      }))
    end

    def delete(key)
      new_hash = data_bag.to_hash.dup.delete(key)

      Chef::Log.info(new_hash)
      update(data_bag.to_hash.dup.delete(key))
    end

    private

    def update(new_data_bag_hash)
      secret = Chef::EncryptedDataBagItem.load_secret(Chef::Config[:encrypted_data_bag_secret])
      encrypted_data_hash = Chef::EncryptedDataBagItem.encrypt_data_bag_item(new_data_bag_hash, secret)

      databag_item = Chef::DataBagItem.new
      databag_item.data_bag(@data_bag)
      databag_item.raw_data = encrypted_data_hash
      databag_item.save
    end
  end
end
