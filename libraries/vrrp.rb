module Dbag
  class Vrrp < Dbag::Password

    def generate
      SecureRandom.base64(8)
    end
  end
end
