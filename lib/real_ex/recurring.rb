module RealEx
  module Recurring
    
    class Payer < RealEx::Transaction
      attributes :type, :reference, :title, :firstname, :lastname, :address, :company
      
      def request_type
        @type ||= 'payer-new'
      end

    end
    
    class Card < RealEx::Transaction
      attributes :card, :payer

      def request_type
        @type ||= 'card-new'
      end
    end
    
    class Authorization < RealEx::Transaction
      attributes :payer
    end
    
  end
end