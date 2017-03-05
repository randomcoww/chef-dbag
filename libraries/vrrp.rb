module Dbag
  class RndcKey < Dbag::Password

    def generate
      SecureRandom.base64(8)
    end
  end
end
