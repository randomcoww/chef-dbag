module Dbag
  class RndcKey < Dbag::Password

    def generate
      SecureRandom.base64
    end
  end
end
