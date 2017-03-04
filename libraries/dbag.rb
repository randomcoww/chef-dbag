module Dbag
  class KeyStore

    def initialize(data_bag, data_bag_item)
      @data_bag = data_bag
      @data_bag_item = data_bag_item
    end

    def data_bag
      Chef::EncryptedDataBagItem.load(@data_bag, @data_bag_item)
    rescue
      empty_data_bag
    end

    def empty_data_bag
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
      new_data_bag_hash = data_bag.to_hash
      new_data_bag_hash.delete(key)
      update(new_data_bag_hash)
    end

    private

    def update(new_data_bag_hash)
      new_data_bag_hash.merge!(empty_data_bag)

      secret = Chef::EncryptedDataBagItem.load_secret
      encrypted_data_hash = Chef::EncryptedDataBagItem.encrypt_data_bag_item(new_data_bag_hash, secret)

      databag_item = Chef::DataBagItem.new
      databag_item.data_bag(@data_bag)
      databag_item.raw_data = encrypted_data_hash
      databag_item.save
    end
  end
end
