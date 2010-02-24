module RealEx
  class Card
    include Initializer
    
    attributes :number, :cvv, :expiry_date, :cardholder_name, :type, :issue_number
    
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
    
    def clean_name
      cardholder_name.gsub(/[^a-zA-Z0-9 ]/, '')
    end
  end
end