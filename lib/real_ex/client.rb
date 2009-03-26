module RealEx
  class Client
    def build_hash(hash_string_items)
      first_hash = Digest::SHA1.hexdigest(hash_string_items.join('.'))
      Digest::SHA1.hexdigest("#{first_hash}.#{SHARED_SECRET}")
    end
  
    def xml_request(url, type, &block)
      xml = Builder::XmlMarkup.new(:indent => 2)
      xml.instruct!
      xml.request(:timestamp => @timestamp, :type => type) { |r| block.call(r) }

      h = Net::HTTP.new('epage.payandshop.com', 443)
      h.use_ssl = true
      response = h.request_post(url, xml.target!)
      result = Hpricot.XML(response.body)
      result
    end
  
    def parse(response)
      status = (response/:result).inner_html
      raise RealExError, "#{(response/:message).inner_html} (#{status})" unless status == "00"
    end
  end
end