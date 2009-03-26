require File.dirname(__FILE__) + '/spec_helper.rb'

describe RealEx do
  
  before do
    RealEx.initialise(:shared_secret => "He's a woman", :merchant_id => '123456')
  end
  
  it "should set the shared secret" do
    RealEx.shared_secret.should == "He's a woman"
  end
  
  it "should set the merchant_id" do
    RealEx.merchant_id.should == '123456'
  end
end