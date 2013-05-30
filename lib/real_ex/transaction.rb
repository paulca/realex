module RealEx
  class Transaction
    include Initializer
    attributes :card, :amount, :order_id, :currency, :autosettle, :variable_reference, :remote_uri, :real_vault_uri, :account
    attr_accessor :comments
    attr_accessor :authcode, :pasref
    
    REQUEST_TYPES = ['auth', 'manual', 'offline', 'tss', 'payer-new', 'payer-edit', 'card-new', 'card-update-card', 'card-cancel-card']
    
    def initialize(hash = {})
      super(hash)
      self.comments ||= []
      self.autosettle ||= true
      self.currency ||= RealEx::Config.currency || 'EUR'
      self.remote_uri ||= RealEx::Config.remote_uri || '/epage-remote.cgi'
      self.real_vault_uri ||= RealEx::Config.real_vault_uri || '/epage-remote-plugins.cgi'
      self.account ||= RealEx::Config.account
    end
    
    def request_type
      self.class.name.split('::').last.downcase
    end
    
    def autosettle?
      autosettle
    end
    
    def to_xml(&block)
      xml = RealEx::Client.build_xml(request_type) do |r|
        r.merchantid RealEx::Config.merchant_id
        r.orderid order_id
        r.authcode authcode if authcode
        r.pasref pasref if pasref
        r.account account
        if block_given?
          block.call(r)
        end
        if !comments.empty?
          r.comments do |c|
            comments.each_with_index do |comment,index|
              c.comment(comment, :id => index + 1)
            end
          end
        end
        r.sha1hash hash
      end
    end
    
    def hash
      RealEx::Client.build_hash([RealEx::Client.timestamp, RealEx::Config.merchant_id, order_id, '', '', ''])
    end

    def authorize!
      RealEx::Response.new_from_xml(RealEx::Client.call(remote_uri, to_xml))
    end

  end
  
  class Authorization < Transaction
    attributes :shipping_address, :billing_address, :customer_number, :product_id, :customer_ip_address
    attributes :offline, :manual
    
    def initialize(hash = {})
      super(hash)
      self.manual ||= false
      self.offline ||= false
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
      @request_type ||= 'auth'
    end
    
    def request_type=(type)
      @request_type = type if REQUEST_TYPES.include?(type)
    end
    
    def to_xml
      super do |r|
        r.amount(amount, :currency => currency) unless offline?
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
      end
    end
    
    def hash
      RealEx::Client.build_hash([RealEx::Client.timestamp, RealEx::Config.merchant_id, order_id, (amount unless offline?), (currency unless offline?), (card.number unless offline?)])
    end
    
    def rebate!
      
    end
    
    def void!
      
    end
    
    def settle!
      
    end
    
  end
  
  class Void < Transaction    
  end
  
  class Settle < Transaction
  end
  
  class Rebate < Transaction
    
    attr_accessor :refund_password
    
    def refund_hash
      Digest::SHA1.hexdigest((refund_password || RealEx::Config.refund_password || ''))
    end
    
    def to_xml(&block)
      super do |per|
        per.amount(amount, :currency => currency)
        per.autosettle :flag => autosettle? ? '1' : '0'
        per.refundhash refund_hash
        if !comments.empty?
          per.comments do |c|
            comments.each_with_index do |comment,index|
              c.comment(comment, :id => index + 1)
            end
          end
        end
      end
    end

    
    def hash
      RealEx::Client.build_hash([RealEx::Client.timestamp, RealEx::Config.merchant_id, order_id, amount, currency, ''])
    end
  end
end