require File.dirname(__FILE__) + '/spec_helper.rb'

describe "RealEx::Card" do
  before do
    @card = RealEx::Card.new(
              :number => '4111111111111111',
              :cvv => '509',
              :expiry_date => '0802',
              :cardholder_name => 'Paul Campbell',
              :type => 'VISA',
              :issue_number =>  nil
              )
  end
  
  it "should just save the attributes" do
    @card.number.should == '4111111111111111'
  end
  
  it "should pass the luhn check" do
    @card.passes_luhn_check?.should == true
  end
  
  it "should fail the luhn check if it's an invalid card" do
    @card.number = '1234'
    @card.passes_luhn_check?.should == false
  end
end