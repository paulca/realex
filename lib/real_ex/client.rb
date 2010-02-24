module RealEx
  class Client
    class << self
      
      def timestamp
        Time.now.strftime('%Y%m%d%H%M%S')
      end
      
      def build_hash(hash_string_items)
        first_hash = Digest::SHA1.hexdigest(hash_string_items.join('.'))
        Digest::SHA1.hexdigest("#{first_hash}.#{RealEx::Config.shared_secret}")
      end
  
      def build_xml(type, &block)
        xml = Builder::XmlMarkup.new(:indent => 2)
        xml.instruct!
        xml.request(:timestamp => timestamp, :type => type) { |r| block.call(r) }
        xml.target!
      end
    
      def call(url,xml)
        h = Net::HTTP.new('epage.payandshop.com', 443)
        h.use_ssl = true
        response = h.request_post(url, xml)
        result = Hpricot.XML(response.body)
        result
      end
  
      def parse(response)
        status = (response/:result).inner_html
        raise RealExError, "#{(response/:message).inner_html} (#{status})" unless status == "00"
      end
    end
  end
end