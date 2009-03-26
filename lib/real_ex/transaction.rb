module RealEx
  class Transaction
    include Initializer
    attributes :card, :amount, :order_id, :currency, :autosettle
    
  end
end