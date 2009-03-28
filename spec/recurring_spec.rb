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
              :issue_number     =>  nil
              )
    @payer = RealEx::Recurring::Payer.new(:type => 'Business', :reference => 'boom', :title => 'Mr.', :firstname => 'Paul', :lastname => 'Campbell', :company => 'Contrast')
    @payer.address = RealEx::Address.new(:street => 'My house', :city => 'Dublin', :county => 'Dublin', :post_code => 'Dublin 2', :country => 'Ireland', :country_code => 'IE',
:phone_numbers => { :home => '1234', :work => '1234', :fax => '1234', :mobile => '1234'}, :email => 'paul@contrast.ie')
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
    @payer.to_xml.should == 'banan'
  end
  
  it "should create lovely XML for the card" do
    @card.to_xml.should == 'card XML'
  end
  
  it "should create tasty XML for the authorization" do
    @transaction.to_xml.should == 'bone'
  end
end