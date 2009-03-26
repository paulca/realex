module RealEx
  class Transaction
    include Initializer
    attributes :card, :amount, :order_id, :currency, :autosettle, :shipping_address, :billing_address
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
      RealEx::Client.build_xml('auth') do |r|
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
          t.custnum billing_address.id
          t.varref billing_address.id
          t.address :type => 'billing' do |a|
            a.code billing_address.postcode
            a.country billing_address.country.country
          end
          t.address :type => 'shipping' do |a|
            a.code shipping_address.postcode
            a.country shipping_address.country.country
          end
        end
        r.sha1hash build_hash([@timestamp, @merchant_id, @order_ref, @amount, @currency, @card.number])
      end
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