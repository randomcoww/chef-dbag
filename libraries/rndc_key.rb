module Dbag
  class RndcKey < Dbag::Keystore

    def get_or_create(key)
      get(key) || create(key)
    end

    def create(key)
      value = SecureRandom.base64
      put(key, value)
      value
    end
  end
end
