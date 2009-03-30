module RealEx
  module Recurring
    
    class Payer < RealEx::Transaction
      attributes :type, :reference, :title, :firstname, :lastname, :address, :company, :comments
      
      def request_type
        @request_type ||= 'payer-new'
      end
      
      def to_xml
        super do |per|
          per.payer(:type => type, :ref => reference) do |payer|
            payer.title title
            payer.firstname firstname
            payer.lastname lastname
            payer.company company
            payer.address do |add|
                add.line1 = address.line1
                add.line1 = address.line2
                add.line3 = address.line3
                add.city = address.city
                add.county = address.county
                add.postcode = address.post_code
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

    end
    
    class Card < RealEx::Transaction
      attributes :card, :payer

      def request_type
        @request_type ||= 'card-new'
      end
    end
    
    class Authorization < RealEx::Transaction
      attributes :payer
      
      def request_type
        'receipt-in'
      end
    end
    
  end
end