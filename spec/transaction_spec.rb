require File.dirname(__FILE__) + '/spec_helper.rb'

describe "RealEx::Transaction" do
  before do
    RealEx::Config.merchant_id = 'paul'
    RealEx::Config.shared_secret = "She's a man!"
    RealEx::Config.account = 'internet'

    @card = RealEx::Card.new(
              :number           => '4111111111111111',
              :cvv              => '509',
              :expiry_date      => '0802',
              :cardholder_name  => 'Paul Campbell',
              :type             => 'VISA',
              :issue_number     =>  nil
              )
    @transaction = RealEx::Transaction.new(
                    :card         => @card,
                    :amount       => 500,
                    :order_id     => 1234,
                    :currency     => 'EUR',
                    :autosettle   => true
                    )
    RealEx::Client.stub!(:timestamp).and_return('20090326160218')
  end
  
  it "should set up the card" do
    @transaction.card.should == @card
  end
  
  it "should allow setting comments" do
    @transaction.comments << "This is a comment"
    @transaction.comments.should == ["This is a comment"]
  end
  
  it "should build the xml" do
    @transaction.to_xml.should == "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<request type=\"auth\" timestamp=\"20090326160218\">\n  <merchantid>paul</merchantid>\n  <orderid>1234</orderid>\n  <account>internet</account>\n  <amount currency=\"EUR\">500</amount>\n  <card>\n    <number>4111111111111111</number>\n    <expdate>0802</expdate>\n    <chname>Paul Campbell</chname>\n    <type>VISA</type>\n  </card>\n  <autosettle flag=\"1\"/>\n  <tssinfo>\n  </tssinfo>\n  <sha1hash>d979885b0a296469d85ada0f08c5577d857142a0</sha1hash>\n</request>\n"
  end
  
  describe "with addresses" do
    before do
      @transaction.shipping_address = RealEx::Address.new(:post_code => 'Shipping Code', :country => 'Shipping Country')
      @transaction.billing_address = RealEx::Address.new(:post_code => 'Biling Code', :country => 'Billing Country')
    end
    
    it "should add the addresses into the xml" do
      @transaction.to_xml.should == "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<request type=\"auth\" timestamp=\"20090326160218\">\n  <merchantid>paul</merchantid>\n  <orderid>1234</orderid>\n  <account>internet</account>\n  <amount currency=\"EUR\">500</amount>\n  <card>\n    <number>4111111111111111</number>\n    <expdate>0802</expdate>\n    <chname>Paul Campbell</chname>\n    <type>VISA</type>\n  </card>\n  <autosettle flag=\"1\"/>\n  <tssinfo>\n    <address type=\"billing\">\n      <code>Biling Code</code>\n      <country>Billing Country</country>\n    </address>\n    <address type=\"shipping\">\n      <code>Shipping Code</code>\n      <country>Shipping Country</country>\n    </address>\n  </tssinfo>\n  <sha1hash>d979885b0a296469d85ada0f08c5577d857142a0</sha1hash>\n</request>\n"
    end
  end
  
  describe "actually going through" do
    
    it "should parse the response" do
      RealEx::Client.should_receive(:call).and_return(Hpricot.XML('yay'))
      @transaction.authorize
    end
  end
  
  describe "a manual request type" do
    before do
      @transaction.manual = true
      @transaction.authcode = '123456'
    end
    
    it "should allow a manual request" do
      @transaction.to_xml.should == "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<request type=\"manual\" timestamp=\"20090326160218\">\n  <merchantid>paul</merchantid>\n  <orderid>1234</orderid>\n  <authcode>123456</authcode>\n  <account>internet</account>\n  <amount currency=\"EUR\">500</amount>\n  <card>\n    <number>4111111111111111</number>\n    <expdate>0802</expdate>\n    <chname>Paul Campbell</chname>\n    <type>VISA</type>\n  </card>\n  <autosettle flag=\"1\"/>\n  <tssinfo>\n  </tssinfo>\n  <sha1hash>d979885b0a296469d85ada0f08c5577d857142a0</sha1hash>\n</request>\n"
    end
  end
  
end