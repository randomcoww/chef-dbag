module Dbag
  class Password < Dbag::Keystore

    def get_or_create(key)
      get(key) || create(key)
    end

    def create(key)
      value = generate
      put(key, value)
      value
    end

    def generate
      SecureRandom.base64
    end
  end
end
