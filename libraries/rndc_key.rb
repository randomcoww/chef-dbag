module Dbag
  class RndcKey < Dbag::KeyStore

    def get_or_create(key)
      data_bag[key] || create(key)
    end

    def create(key)
      value = SecureRandom.base64
      put(key, value)
      value
    end
  end
end
