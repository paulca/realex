require 'rio'
require 'digest/sha1'
require 'hpricot'
require 'net/https'


class RealExError < StandardError
end

=begin SAMPLE XML:

<?xml version="1.0"?>   
   <request timestamp="20010125012644" type="auth"> 
  <merchantid>771017409</merchantid>  
  <account>eason</account> 
  <orderid> 1020389 </orderid>  
  <amount currency="EUR"> 12500 </amount>  
   <card> 
  <number> 4111111111111111 </number>  
  <expdate> 0302 </expdate>  
  <chname> John Smith </chname>  
  <type> VISA </type>  
  </card> 
  <autosettle flag="0" />  
   <comments> 
  <comment id="1"> Testing </comment>  
  <comment id="2" />  
  </comments> 
   <tssinfo> 
  <custnum> 72389423 </custnum>  
  <varref> 3849 </varref>  
  <address type="billing"> 
  <code> 12 </code>  
  <country> Ireland </country>  
  </address> 
  <address type="shipping"> 
  <code> 12 </code>  
  <country> Ireland </country>  
  </address> 
  </tssinfo> 
  <md5hash> f07b2de75e1cd80c3f95f325cd8bd1bb </md5hash>  
  </request>
=end  
  
=begin  
    Constructing the hash:

    Here’s a fragment of a sample XML message: 

      <request timestamp="20010403123245" type="auth"> 
      <merchantid> thestore </merchantid>  
      <orderid> ORD453-11 </orderid>  
      <amount currency="EUR"> 29900 </amount>  
       <card> 
      <number> 5105105105105100 </number>  
      <expdate> 0302 </expdate>  
      <chname> John Smith </chname>  
      <type> VISA </type>  
          </card> 


    To construct the hash follow this procedure: 

    Form a string by concatenating the above fields with a period (“.”)  
    ( 20010403123245.thestore.ORD453-11.29900.EUR.5105105105105100 ) 

=end

class RealEx
  SHARED_SECRET = ''
  MERCHANT_ID = ''

  def initialize(card, amount, order_ref, options = {})
    @card = card
    @amount = amount
    @merchant_id = MERCHANT_ID
    @account = (RAILS_ENV == 'production') ? 'internet' : 'internettest'
    @currency = options[:currency] || 'EUR'
    @autosettle = options[:autosettle] || '0'
    @timestamp = Time.now.strftime('%Y%m%d%H%M%S')
    @order_ref = order_ref
  end
  
  def authorise!(billing_address, shipping_address)
    authorisation_code, pasref = authorise(billing_address, shipping_address)
    new_payer(billing_address.firstname, billing_address.lastname)
    new_card
    return [authorisation_code, pasref]
  end
  
  def authorise(billing_address, shipping_address)
    response = xml_request('/epage-remote.cgi', 'auth') do |r|
      r.merchantid @merchant_id
      r.orderid @order_ref
      r.account @account
      r.amount(@amount, :currency => @currency)
      r.card do |c|
        c.number @card.number
        c.expdate @card.expiry_date
        c.chname @card.clean_name
        c.type @card.card_type
      end
      r.autosettle :flag => @autosettle
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
    case (response/:result).inner_html
      when '00' then return [(response/:authcode).inner_html, (response/:pasref).inner_html]
      when '101', '102', '103' then raise RealExError, "We are having difficulties processing your credit card."
      when '205' then raise RealExError, "There was an error connecting to the bank.  Please try again."
      when '501' then raise RealExError, "The transaction has already been processed."
      else raise RealExError, (response/:message).inner_html
    end
  end
  
  def new_payer(firstname, surname)
    response = xml_request('/epage-remote-plugins.cgi', 'payer-new') do |r|
      r.merchantid @merchant_id
      r.orderid @order_ref
      r.amount @amount
      r.payer(:type => 'Internet', :ref => @order_ref) do |p|
        p.firstname firstname
        p.surname surname
      end
      r.sha1hash build_hash([@timestamp, @merchant_id, @order_ref, '', '', @order_ref])
    end
    parse(response)
  end
  
  def new_card
    response = xml_request('/epage-remote-plugins.cgi', 'card-new') do |r|
      r.merchantid @merchant_id
      r.orderid @order_ref
      r.card do |c|
        c.ref @order_ref
        c.payerref @order_ref
        c.number @card.number
        c.expdate @card.expiry_date
        c.chname @card.clean_name
        c.type @card.card_type
      end
      r.sha1hash build_hash([@timestamp, @merchant_id, @order_ref, '', '', @order_ref, @card.clean_name, @card.number] )
    end
    parse(response)
  end
  
  def make_payment(payment_id)
    payment_reference = "#{@order_ref}-#{payment_id}"
    response = xml_request('/epage-remote-plugins.cgi', 'receipt-in') do |r|
      r.merchantid @merchant_id
      r.account @account
      r.orderid payment_reference
      r.amount(@amount, :currency => @currency) 
      r.payerref @order_ref
      r.paymentmethod @order_ref
      r.sha1hash build_hash([@timestamp, @merchant_id, payment_reference, @amount, @currency, @order_ref])
    end
    case (response/:result).inner_html
      when '00' then return [(response/:authcode).inner_html, (response/:pasref).inner_html]
      when '101', '102', '103' then raise RealExError, "We are having difficulties processing your credit card."
      when '205' then raise RealExError, "There was an error connecting to the bank.  Please try again."
      when '501' then raise RealExError, "The transaction has already been processed."
      else raise RealExError, (response/:message).inner_html
    end
  end
  
=begin
<request timestamp="20010427124312" type="rebate"> 
 <merchantid>merchantid</merchantid>  
 <account>original-subaccount</account>  
 <orderid>original-orderid</orderid>  
 <pasref>original-realex-payments-pasref</pasref>  
 <authcode>original-authcode</authcode>  
 <amount currency="EUR">3000</amount>  
 <refundhash>738e83....3434ddae662a</refundhash> 
 <autosettle flag="1" />  
 <comments> 
  <comment id="1">comment 1</comment>  
  <comment id="2">comment 2</comment>  
 </comments> 
 <sha1hash>748328aed83....34789ade7</sha1hash>   
 <md5hash>738e83....34ae662a</md5hash>  
</request> 
=end  
  def rebate(passref, authcode, rebate_password)
    response = xml_request('/epage-remote.cgi', 'rebate') do |r|
      r.merchantid @merchant_id
      r.account @account
      r.orderid @order_ref
      r.pasref passref
      r.authcode authcode
      r.amount(@amount, :currency => @currency)
      r.autosettle :flag => @autosettle
      r.refundhash Digest::SHA1.hexdigest(rebate_password)
      r.sha1hash build_hash([@timestamp, @merchant_id, @order_ref, @amount, @currency, ''])
    end
    parse(response)
  end

  
  def void(passref, authcode)
    response = xml_request('/epage-remote.cgi', 'void') do |r|
      r.merchantid @merchant_id
      r.account @account
      r.orderid @order_ref
      r.pasref passref
      r.authcode authcode
      r.sha1hash build_hash([@timestamp, @merchant_id, @order_ref, '', '', ''])
    end
    parse(response)
  end
=begin
<request timestamp="20010427014523" type="settle"> 
 <merchantid>merchantid</merchantid>  
 <account>subaccount</account>  
 <orderid>original-orderid</orderid>  
 <pasref>original-realex-payments-pasref</pasref>  
 <authcode>original-authcode</authcode>  
 <comments> 
  <comment id="1">comment 1</comment>  
  <comment id="2">comment 2</comment>  
 </comments> 
 <sha1hash>7384ae67....ac7d7d</sha1hash>  
 <md5hash>34e7....a77d</md5hash>  
</request>
=end
  def settle(passref, authcode)
    response = xml_request('/epage-remote.cgi', 'settle') do |r|
      r.merchantid @merchant_id
      r.account @account
      r.orderid @order_ref
      r.pasref passref
      r.authcode authcode
      r.sha1hash build_hash([@timestamp, @merchant_id, @order_ref, '', '', ''])
    end
    parse(response)
  end
  
  private
  
  def build_hash(hash_string_items)
    first_hash = Digest::SHA1.hexdigest(hash_string_items.join('.'))
    Digest::SHA1.hexdigest("#{first_hash}.#{SHARED_SECRET}")
  end
  
  def xml_request(url, type, &block)
    xml = Builder::XmlMarkup.new(:indent => 2)
    xml.instruct!
    xml.request(:timestamp => @timestamp, :type => type) { |r| block.call(r) }

    h = Net::HTTP.new('epage.payandshop.com', 443)
    h.use_ssl = true
    response = h.request_post(url, xml.target!)
    result = Hpricot.XML(response.body)
    result
  end
  
  def parse(response)
    status = (response/:result).inner_html
    raise RealExError, "#{(response/:message).inner_html} (#{status})" unless status == "00"
  end
  
end