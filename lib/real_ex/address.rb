module RealEx
  class Address
    include Initializer
    attributes :street, :city, :county
    attributes :post_code, :country, :country_code, :phone_numbers, :email
    
    [1,2,3].each do |line|
      class_eval do
        define_method("line#{line}") do
          street.split("\n")[line - 1]
        end
      end
    end
  end
end