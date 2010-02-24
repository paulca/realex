RealEx library for interfacing with www.realexpayments.com

require 'real_ex'

RealEx::Config.shared_secret = 'YOUR SHARED SECRET'
RealEx::Config.merchant_id = 'YOUR MERCHANT ID'

card = RealEx::Card.new(:number => '4263971921001307', :cvv => '509', :expiry_date => '0822', :cardholder_name => 'Paul Campbell', :type => 'VISA')

transaction = RealEx::Authorization.new(
:customer_number => 1234, :variable_reference => 1234,
:card => card, :amount => 500, :order_id => 12345, :currency => 'EUR', :autosettle => true)

transaction.comments << "Here's a comment"

transaction.to_xml

transaction.shipping_address = RealEx::Address.new(:type => 'shipping', :code => 'Postal Code', :country => 'Country')

transaction.billing_address = RealEx::Address.new(:type => 'billing', :code => 'Postal Code', :country => 'Country')

transaction.authorize!

Manual Request Type

transaction.manual = true
transaction.authcode = '12345'

transaction.authorize!


More notes:

Here's how it works:

require 'real_ex'

RealEx::Config.shared_secret = ''
RealEx::Config.merchant_id = ''


order_id = '12r3213'

card = RealEx::Card.new(:number => '4***************', :cvv => '509', :expiry_date => '0822', :cardholder_name => 'Paul Campbell', :type => 'VISA')

transaction = RealEx::Authorization.new(
:customer_number => 1234, :variable_reference => 1234,
:card => card, :amount => 500, :order_id => order_id, :currency => 'EUR', :autosettle => true)

transaction.comments << "Here's a comment"

transaction.to_xml

transaction.shipping_address = RealEx::Address.new(:type => 'shipping', :code => 'Postal Code', :country => 'Country')

transaction.billing_address = RealEx::Address.new(:type => 'billing', :code => 'Postal Code', :country => 'Country')

transaction.authorize!

Recurring payments

payer = RealEx::Recurring::Payer.new(:type => 'Business', :reference => 'boom', :title => 'Mr.', :firstname => 'Paul', :lastname => 'Campbell', :company => 'Hyper Tiny')

payer.address = RealEx::Address.new(:street => '64 Dame Street', :city => 'Dublin', :county => 'Dublin', :post_code => 'Dublin 3', :country => 'Ireland', :country_code => 'IE', :phone_numbers => { :home => '1234', :work => '1234', :fax => '1234', :mobile => '1234'}, :email => 'paul@rslw.com')

payer.save!

card = RealEx::Recurring::Card.new(:payer => payer)

card.card = card

card.save

transaction = RealEx::Recurring::Authorization.new(:amount => 500, :payer => payer, :order_id => order_id)

