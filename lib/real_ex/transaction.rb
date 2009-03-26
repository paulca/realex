module RealEx
  class Transaction
    include Initializer
    attributes :card, :amount, :order_id, :currency, :autosettle, :shipping_address, :billing_address, :customer_number, :variable_reference, :product_id, :customer_ip_address
    attr_accessor :comments
    
    def initialize(hash)
      super(hash)
      self.comments ||= []
      self.autosettle ||= false
    end
    
    def autosettle?
      autosettle
    end
    
    def to_xml
      xml = RealEx::Client.build_xml('auth') do |r|
        r.merchantid RealEx::Config.merchant_id
        r.orderid order_id
        r.account RealEx::Config.account
        r.amount(amount, :currency => currency)
        r.card do |c|
          c.number card.number
          c.expdate card.expiry_date
          c.chname card.clean_name
          c.type card.type
        end
        r.autosettle :flag => autosettle? ? '1' : '0'
        r.tssinfo do |t|
          t.custnum customer_number if customer_number
          t.varref variable_reference if variable_reference
          t.prodid product_id if product_id
          t.custipaddress customer_ip_address if customer_ip_address
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
        r.sha1hash hash
      end
    end
    
    def hash
      RealEx::Client.build_hash([RealEx::Client.timestamp, RealEx::Config.merchant_id, order_id, amount, currency, card.number])
    end

    def authorise(billing_address, shipping_address)
      response = xml_request('/epage-remote.cgi', 'auth') do |r|
      end
      case (response/:result).inner_html
        when '00' then return [(response/:authcode).inner_html, (response/:pasref).inner_html]
        when '101', '102', '103' then raise RealExError, "We are having difficulties processing your credit card."
        when '205' then raise RealExError, "There was an error connecting to the bank.  Please try again."
        when '501' then raise RealExError, "The transaction has already been processed."
        else raise RealExError, (response/:message).inner_html
      end
    end

  end
end