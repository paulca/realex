require File.dirname(__FILE__) + '/spec_helper.rb'

describe "RealEx::Config" do
  before do
    RealEx::Config.shared_secret = "He's actually a woman"
    RealEx::Config.proxy_uri = "example.com"
  end

  it "should set the shared_secret" do
    RealEx::Config.shared_secret.should == "He's actually a woman"
  end

  it "should set the proxy_uri" do
    RealEx::Config.proxy_uri.should == "example.com"
  end
end
