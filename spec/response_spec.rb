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

describe "RealEx::Response" do
  before do
    @response = RealEx::Response.new_from_xml(%Q[<?xml version="1.0" encoding="UTF-8" ?>
<response timestamp="20090326171616">
<merchantid>test</merchantid>
<account>Realex</account>
<orderid>12345</orderid>
<authcode>171616</authcode>
<result>00</result>
<cvnresult>U</cvnresult>
<avspostcoderesponse>U</avspostcoderesponse>
<avsaddressresponse>U</avsaddressresponse>
<batchid>136</batchid>
<message>[ test system ] Authorised 171616</message>
<pasref>12380877763476</pasref>
<timetaken>1</timetaken>
<authtimetaken>0</authtimetaken>
<cardissuer>
<bank>AIB BANK</bank>
<country>IRELAND</country>
<countrycode>IE</countrycode>
<region>EUR</region>
</cardissuer>])
  end
  
  it "should build the object" do
    @response.timestamp.should == '20090326171616'
    @response.merchantid.should == 'test'
    @response.account.should == 'Realex'
    @response.orderid.should == '12345'
    @response.cardissuer.bank.should == 'AIB BANK'
    @response.cvnresult.should == 'U'
    @response.cvnresult.should == 'U'
    @response.avspostcoderesponse.should == 'U'
    @response.avsaddressresponse.should == 'U'
    @response.batchid.should == '136'
    @response.message.should == '[ test system ] Authorised 171616'
    @response.pasref.should == '12380877763476'
    @response.timetaken.should == '1'
    @response.authcode.should== "171616"
    @response.authtimetaken.should == '0'
    @response.cardissuer.country.should == 'IRELAND'
    @response.cardissuer.countrycode.should == 'IE'
    @response.cardissuer.region.should == 'EUR'
  end
end