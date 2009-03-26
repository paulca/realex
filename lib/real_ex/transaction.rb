module RealEx
  class Transaction
    include Initializer
    attributes :card, :amount, :order_id, :currency, :autosettle
    attr_accessor :comments
    
    def initialize(hash)
      super(hash)
      self.comments ||= []
    end
    
    def to_xml
      
    end
  end
end