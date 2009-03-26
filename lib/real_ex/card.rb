module RealEx
  class Card
    attr_accessor :number, :cvv, :expiry_date, :cardholder_name, :type, :issue_number
    
    def initialize(attributes = {})
      attributes.each { |k, v| send("#{k}=", v) } unless attributes.nil?
    end
    
    # The luhn check is a check to see if a credit card
    # is actually a credit card or not
    def passes_luhn_check?
      odd = true
      luhn = number.to_s.gsub(/\D/,'').reverse.split('').collect { |d|
        d = d.to_i
        d *= 2 if odd = !odd
        d > 9 ? d - 9 : d
      }.inject(0) { |sum,number| sum + number }
      luhn % 10 == 0
    end
  end
end