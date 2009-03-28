module RealEx
  class Address
    include Initializer
    attributes :street, :city, :county
    attributes :post_code, :country, :country_code, :phone_numbers, :email
  end
end