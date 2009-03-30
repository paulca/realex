require File.dirname(__FILE__) + '/spec_helper.rb'

describe "RealEx::Recurring" do
  before do
    RealEx::Config.merchant_id = 'paul'
    RealEx::Config.shared_secret = "He's not dead, he's just asleep!"
    RealEx::Config.account = 'internet'

    @card = RealEx::Card.new(
              :number           => '4111111111111111',
              :cvv              => '509',
              :expiry_date      => '0802',
              :cardholder_name  => 'Paul Campbell',
              :type             => 'VISA',
              :issue_number     =>  nil,
              :reference => 'billabong'
              )
    @payer = RealEx::Recurring::Payer.new(:type => 'Business', :reference => 'boom', :title => 'Mr.', :firstname => 'Paul', :lastname => 'Campbell', :company => 'Contrast')
    @payer.address = RealEx::Address.new(:street => 'My house', :city => 'Dublin', :county => 'Dublin', :post_code => 'Dublin 2', :country => 'Ireland', :country_code => 'IE',
:phone_numbers => { :home => '1', :work => '2', :fax => '3', :mobile => '4'}, :email => 'paul@contrast.ie')
    @card = RealEx::Recurring::Card.new(:payer => @payer, :card => @card)
    @transaction = RealEx::Recurring::Authorization.new(
                    :payer         => @payer,
                    :amount       => 500,
                    :order_id     => 1234,
                    :currency     => 'EUR',
                    :autosettle   => true
                    )
    RealEx::Client.stub!(:timestamp).and_return('20090326160218')
  end
  
  it "should create tasty XML for the payer" do
    @payer.to_xml.should == "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<request type=\"payer-new\" timestamp=\"20090326160218\">\n  <merchantid>paul</merchantid>\n  <orderid></orderid>\n  <account>internet</account>\n  <payer type=\"Business\" ref=\"boom\">\n    <title>Mr.</title>\n    <firstname>Paul</firstname>\n    <lastname>Campbell</lastname>\n    <company>Contrast</company>\n    <address>\n      <line1=>My house</line1=>\n      <line1=></line1=>\n      <line3=></line3=>\n      <city=>Dublin</city=>\n      <county=>Dublin</county=>\n      <postcode=>Dublin 2</postcode=>\n      <country country_code=\"IE\">Ireland</country>\n    </address>\n    <phonenumbers>\n      <home>1</home>\n      <work>2</work>\n      <fax>3</fax>\n      <mobile>4</mobile>\n    </phonenumbers>\n    <email>paul@contrast.ie</email>\n  </payer>\n  <sha1hash>7e97b1b743c2599b6c1fd0c5515d369d8372df15</sha1hash>\n</request>\n"
  end
  
  it "should create tasty XML for the payer update" do
    @payer.update = true
    @payer.to_xml.should == "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<request type=\"payer-edit\" timestamp=\"20090326160218\">\n  <merchantid>paul</merchantid>\n  <orderid></orderid>\n  <account>internet</account>\n  <payer type=\"Business\" ref=\"boom\">\n    <title>Mr.</title>\n    <firstname>Paul</firstname>\n    <lastname>Campbell</lastname>\n    <company>Contrast</company>\n    <address>\n      <line1=>My house</line1=>\n      <line1=></line1=>\n      <line3=></line3=>\n      <city=>Dublin</city=>\n      <county=>Dublin</county=>\n      <postcode=>Dublin 2</postcode=>\n      <country country_code=\"IE\">Ireland</country>\n    </address>\n    <phonenumbers>\n      <home>1</home>\n      <work>2</work>\n      <fax>3</fax>\n      <mobile>4</mobile>\n    </phonenumbers>\n    <email>paul@contrast.ie</email>\n  </payer>\n  <sha1hash>7e97b1b743c2599b6c1fd0c5515d369d8372df15</sha1hash>\n</request>\n"
  end
  
  it "should create lovely XML for the card" do
    @card.to_xml.should == "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<request type=\"card-new\" timestamp=\"20090326160218\">\n  <merchantid>paul</merchantid>\n  <orderid></orderid>\n  <account>internet</account>\n  <card>\n    <ref>billabong</ref>\n    <payerref>boom</payerref>\n    <number>4111111111111111</number>\n    <expdate>0802</expdate>\n    <chname>Paul Campbell</chname>\n    <type>VISA</type>\n  </card>\n  <sha1hash>24dc62271ccaddc59082b4db45c80b0241f630f7</sha1hash>\n</request>\n"
  end
  
  it "should create lovely XML for the card update" do
    @card.update = true
    @card.to_xml.should == "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<request type=\"eft-update-expiry-date\" timestamp=\"20090326160218\">\n  <merchantid>paul</merchantid>\n  <orderid></orderid>\n  <account>internet</account>\n  <card>\n    <ref>billabong</ref>\n    <payerref>boom</payerref>\n    <number>4111111111111111</number>\n    <expdate>0802</expdate>\n    <chname>Paul Campbell</chname>\n    <type>VISA</type>\n  </card>\n  <sha1hash>a97a52b7e5afa2980f4298251c2b8b836fd82331</sha1hash>\n</request>\n"
  end
  
  it "should create tasty XML for the authorization" do
    @transaction.to_xml.should == "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<request type=\"receipt-in\" timestamp=\"20090326160218\">\n  <merchantid>paul</merchantid>\n  <orderid>1234</orderid>\n  <account>internet</account>\n  <amount currency=\"EUR\">500</amount>\n  <payerref>boom</payerref>\n  <paymentmethod:reference/>\n  <tssinfo>\n  </tssinfo>\n  <sha1hash>ec3afd1714b4473210c2b1eda0c6675bd13c411b</sha1hash>\n</request>\n"
  end
end