require File.dirname(__FILE__) + '/spec_helper.rb'
# <?xml version="1.0" ?>
# <response timestamp="20090326164411">
# <result>501</result>
# <message>This transaction (1234) has already been processed! If you feel this is incorrect please contact the merchant!</message>
# <orderid>1234</orderid>
# </response>
describe "RealEx::Response" do
  before do
    @response = RealEx::Response.new_from_xml(%Q[<?xml version="1.0" ?>
<response timestamp="20090326164411">
<result>501</result>
<message>This transaction (1234) has already been processed! If you feel this is incorrect please contact the merchant!</message>
<orderid>1234</orderid>
</response>])
  end
  
  it "should build the object" do
    @response.timestamp.should == '20090326164411'
    @response.result.should == '501'
    @response.message.should == 'This transaction (1234) has already been processed! If you feel this is incorrect please contact the merchant!'
    @response.orderid.should == '1234'
  end
end