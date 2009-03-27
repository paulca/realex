module RealEx
  class Config
    class << self
      attr_accessor :shared_secret, :merchant_id, :account, :refund_password, :currency
    end
  end
end