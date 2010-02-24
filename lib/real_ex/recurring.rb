module RealEx
  module Recurring
    
    class Transaction < RealEx::Transaction
      def authorize!
        RealEx::Response.new_from_xml(RealEx::Client.call('/epage-remote-plugins.cgi', to_xml))
      end
    end
    
    class Payer < Transaction
      attributes :type, :reference, :title, :firstname, :lastname, :address, :company, :comments
      attributes :update
      
      def request_type
        @request_type = update == true ? 'payer-edit' : 'payer-new'
      end
      
      def to_xml
        super do |per|
          per.payer(:type => type, :ref => reference) do |payer|
            payer.title title
            payer.firstname firstname
            payer.lastname lastname
            payer.company company
            payer.address do |add|
                add.line1 address.line1
                add.line1 address.line2
                add.line3 address.line3
                add.city address.city
                add.county address.county
                add.postcode address.post_code
              add.country(address.country, :country_code => address.country_code)
            end
            payer.phonenumbers do |numbers|
              numbers.home address.phone_numbers[:home]
              numbers.work address.phone_numbers[:work]
              numbers.fax address.phone_numbers[:fax]
              numbers.mobile address.phone_numbers[:mobile]
            end
            payer.email address.email
            if !comments.empty?
              payer.comments do |c|
                comments.each_with_index do |i,comment|
                  c.comment(comment, :id => i + 1)
                end
              end
            end
          end
        end
      end

      # 20030516175919.yourmerchantid.uniqueid…smithj01
      def hash
        RealEx::Client.build_hash([RealEx::Client.timestamp, RealEx::Config.merchant_id, order_id, '', '', reference])
      end
      
      def save!
        authorize!
      end
      
      def update!
        self.update = true
        authorize!
      end

    end
    
    class Card < Transaction
      attributes :card, :payer, :update, :reference

      def request_type
        @request_type = update == true ? 'eft-update-expiry-date' : 'card-new'
      end
      
      def to_xml
        super do |per|
          per.card do |c|
            c.ref reference
            c.payerref payer.reference
            c.number card.number
            c.expdate card.expiry_date
            c.chname card.cardholder_name
            c.type card.type
          end
        end
      end
      
      # 20030516181127.yourmerchantid.uniqueid…smithj01.John Smith.498843******9991
      def hash
        if update == true
          RealEx::Client.build_hash([RealEx::Client.timestamp, RealEx::Config.merchant_id, payer.reference, card.reference,card.expiry_date])
        else
          RealEx::Client.build_hash([RealEx::Client.timestamp, RealEx::Config.merchant_id, order_id, '', '', payer.reference,card.cardholder_name,card.number])
        end
      end
      
      def save!
        authorize!
      end
      
      def update!
        self.update = true
        authorize!
      end

    end
    
    class Authorization < Transaction
      attributes :payer, :reference, :customer_number, :variable_reference, :product_id
      attributes :billing_address, :shipping_address
      
      def request_type
        'receipt-in'
      end
      
      def to_xml
        super do |per|
          per.amount(amount, :currency => currency)
          per.payerref payer.reference
          per.paymentmethod reference
          if customer_number or variable_reference or billing_address or shipping_address
            per.tssinfo do |t|
              t.custnum customer_number if customer_number
              t.varref variable_reference if variable_reference
              t.prodid product_id if product_id
              if billing_address
                t.address :type => 'billing' do |a|
                  a.code billing_address.post_code
                  a.country billing_address.country
                end
              end
              if shipping_address
                t.address :type => 'shipping' do |a|
                  a.code shipping_address.post_code
                  a.country shipping_address.country
                end
              end
            end
          end
        end
      end
      
      # timesttimestamp.merchantid.orderid.amount.currency.payerref
      def hash
        RealEx::Client.build_hash([RealEx::Client.timestamp, RealEx::Config.merchant_id, order_id, amount, currency, payer.reference])
      end
      
    end
    
  end
end