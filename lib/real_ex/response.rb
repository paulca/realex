module RealEx
  class Response
    
    include Initializer
    
    attributes :timestamp, :result, :message, :orderid
    
    def self.new_from_xml(xml)
      parsed_xml = xml.kind_of?(String) ? Hpricot.XML(xml) : xml
      r = new
      r.timestamp = (parsed_xml).at('response')['timestamp'] if (parsed_xml).at('response')
      r.result = (parsed_xml).at('result').inner_html if (parsed_xml).at('result')
      r.message = (parsed_xml).at('message').inner_html if (parsed_xml).at('message')
      r.orderid = (parsed_xml).at('orderid').inner_html if (parsed_xml).at('orderid')
      r
    end
  end
end