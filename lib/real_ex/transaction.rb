module RealEx
  class Transaction
    include Initializer
    attributes :card, :amount, :order_id, :currency, :autosettle, :shipping_address, :billing_address, :customer_number, :variable_reference, :product_id, :customer_ip_address
    attr_accessor :comments
    attr_accessor :offline, :manual, :authcode, :pasref
    
    REQUEST_TYPES = ['auth', 'manual', 'offline']
    
    def initialize(hash)
      super(hash)
      self.comments ||= []
      self.autosettle ||= false
      self.manual ||= false
      self.offline ||= false
    end
    
    def autosettle?
      autosettle
    end
    
    REQUEST_TYPES.each do |type|
      class_eval do
        define_method("#{type}=") do |boolean|  # def manual=(boolean)
          self.request_type = type if boolean   #   self.request_type = 'manual' if boolean
        end                                     # end

        define_method("#{type}?") do            # def manual?
          request_type == type                  #   request_type == 'manual'
        end                                     # end
      end
    end
    
    def request_type
      @type ||= 'auth'
    end
    
    def request_type=(type)
      @type = type if REQUEST_TYPES.include?(type)
    end
    
    def to_xml
      xml = RealEx::Client.build_xml(request_type) do |r|
        r.merchantid RealEx::Config.merchant_id
        r.orderid order_id
        r.authcode authcode if authcode
        r.pasref pasref if pasref
        r.account RealEx::Config.account
        r.amount(amount, :currency => currency) unless offline?
        if !comments.empty?
          r.comments do |c|
            comments.each_with_index do |index,comment|
              c.comment(comment, :id => index)
            end
          end
        end
        if !offline?
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
        end
        r.sha1hash hash
      end
    end
    
    def hash
      RealEx::Client.build_hash([RealEx::Client.timestamp, RealEx::Config.merchant_id, order_id, (amount unless offline?), (currency unless offline?), (card.number unless offline?)])
    end

    def authorize!
      RealEx::Response.new_from_xml(RealEx::Client.call('/epage-remote.cgi', to_xml))
    end

  end
  
  class Rebate < Transaction
    
    attr_accessor :refund_password
    
    def refund_hash
      Digest::SHA1.hexdigest((refund_password || RealEx::Config.refund_password || ''))
    end
    
    def to_xml(&block)
      xml = RealEx::Client.build_xml(request_type) do |r|
        r.merchantid RealEx::Config.merchant_id
        r.orderid order_id
        r.authcode authcode if authcode
        r.pasref pasref if pasref
        r.account RealEx::Config.account
        r.amount(amount, :currency => currency)
        r.autosettle :flag => autosettle? ? '1' : '0'
        r.refundhash refund_hash
        if !comments.empty?
          r.comments do |c|
            comments.each_with_index do |index,comment|
              c.comment(comment, :id => index)
            end
          end
        end
        r.sha1hash hash
      end
    end

    
    def hash
      RealEx::Client.build_hash([RealEx::Client.timestamp, RealEx::Config.merchant_id, order_id, amount, currency, ''])
    end
  end
end