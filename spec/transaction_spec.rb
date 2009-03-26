require File.dirname(__FILE__) + '/spec_helper.rb'

describe "RealEx::Transaction" do
  before do
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
  end
  
  it "should set up the card" do
    @transaction.card.should == @card
  end
  
  it "should allow setting comments" do
    @transaction.comments << "This is a comment"
    @transaction.comments.should == ["This is a comment"]
  end
  
  it "should build the xml" do
    @transaction.to_xml.should == ""
  end
  
end