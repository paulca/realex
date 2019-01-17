module RealEx
  class Client
    class << self
      def timestamp
        Time.now.strftime("%Y%m%d%H%M%S")
      end

      def build_hash(hash_string_items, shared_secret = RealEx::Config.shared_secret)
        first_hash = Digest::SHA1.hexdigest(hash_string_items.join("."))
        Digest::SHA1.hexdigest("#{first_hash}.#{shared_secret}")
      end

      def build_xml(type, &block)
        xml = Builder::XmlMarkup.new(:indent => 2)
        xml.instruct!
        xml.request(:type => type, :timestamp => timestamp) { |r| block.call(r) }
        xml.target!
      end

      def call(url,xml)
        base_uri = "epage.payandshop.com"
        port = 443
        proxy = RealEx::Config.proxy_uri ? URI(RealEx::Config.proxy_uri) : nil

        http =
          if proxy
            Net::HTTP.new(base_uri, port, proxy.host, proxy.port, proxy.user, proxy.password)
          else
            Net::HTTP.new(base_uri, port)
          end

        http.use_ssl = true

        response = http.request_post(url, xml)
        result = Nokogiri.XML(response.body)
        result
      end

      def parse(response)
        status = (response/:result).inner_html
        raise RealExError, "#{(response/:message).inner_html} (#{status})" unless status == "00"
      end
    end
  end
end
