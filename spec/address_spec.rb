require File.dirname(__FILE__) + '/spec_helper.rb'

describe "RealEx::Address" do
  before do
    @address = RealEx::Address.new(
              :post_code => '1234',
              :country => 'Ireland'
              )
  end
  
  it "should just save the attributes" do
    @address.post_code.should == '1234'
  end
  
  it "should just save the attributes" do
    @address.country.should == 'Ireland'
  end
  
end