module RealEx
  class Address
    include Initializer
    attributes :street, :city, :county
    attributes :post_code, :country, :country_code, :phone_numbers, :email
    
    def initialize(*args)
      super
      @phone_numbers ||= {}
    end
    
    [1,2,3].each do |line|
      class_eval do
        define_method("line#{line}") do
          street.to_s.split("\n")[line - 1]
        end
      end
    end
  end
end