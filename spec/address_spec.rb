require File.dirname(__FILE__) + '/spec_helper.rb'

describe "RealEx::Address" do
  before do
    @address = RealEx::Address.new(
              :post_code => '1234',
              :country => 'Ireland',
              :street => "99 Street view,\nholleraino\npicksville"
              )
  end
  
  it "should just save the attributes" do
    @address.post_code.should == '1234'
  end
  
  it "should just save the attributes" do
    @address.country.should == 'Ireland'
  end
  
  it "should have line1 line2 and line3" do
    @address.line1.should == "99 Street view,"
    @address.line2.should == "holleraino"
    @address.line3.should == "picksville"
  end
  
end