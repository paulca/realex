module RealEx
  class Config
    class << self
      attr_accessor :shared_secret, :merchant_id, :account, :refund_password, :currency, :remote_uri, :real_vault_uri
    end
  end
end