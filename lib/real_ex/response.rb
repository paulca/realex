module RealEx
  class Response
    class CardIssuer
      include Initializer
      attributes :bank, :country, :countrycode, :region
    end
    
    include Initializer
    
    attributes :timestamp, :result, :message, :orderid, :merchantid, :account, :cvnresult, :avspostcoderesponse, :pasref, :timetaken, :authtimetaken, :batchid, :avsaddressresponse, :cardissuer
    
    def self.new_from_xml(xml)
      parsed_xml = xml.kind_of?(String) ? Nokogiri.XML(xml) : xml
      r = new
      r.timestamp = (parsed_xml).at('response')['timestamp'] if (parsed_xml).at('response')
      r.result = (parsed_xml).at('result').inner_html if (parsed_xml).at('result')
      r.message = (parsed_xml).at('message').inner_html if (parsed_xml).at('message')
      r.orderid = (parsed_xml).at('orderid').inner_html if (parsed_xml).at('orderid')
      r.merchantid = (parsed_xml).at('merchantid').inner_html if (parsed_xml).at('merchantid')
      r.account = (parsed_xml).at('account').inner_html if (parsed_xml).at('account')
      r.cvnresult = (parsed_xml).at('cvnresult').inner_html if (parsed_xml).at('cvnresult')
      r.avspostcoderesponse = (parsed_xml).at('avspostcoderesponse').inner_html if (parsed_xml).at('avspostcoderesponse')
      r.avsaddressresponse = (parsed_xml).at('avsaddressresponse').inner_html if (parsed_xml).at('avsaddressresponse')
      r.batchid = (parsed_xml).at('batchid').inner_html if (parsed_xml).at('batchid')
      r.pasref = (parsed_xml).at('pasref').inner_html if (parsed_xml).at('pasref')
      r.timetaken = (parsed_xml).at('timetaken').inner_html if (parsed_xml).at('timetaken')
      r.authtimetaken = (parsed_xml).at('authtimetaken').inner_html if (parsed_xml).at('authtimetaken')
      if cardissuer = (parsed_xml).at('cardissuer')
        r.cardissuer = CardIssuer.new()
        r.cardissuer.bank = cardissuer.at('bank').inner_html
        r.cardissuer.country = cardissuer.at('country').inner_html
        r.cardissuer.countrycode = cardissuer.at('countrycode').inner_html
        r.cardissuer.region = cardissuer.at('region').inner_html
      end
      r
    end
  end
end