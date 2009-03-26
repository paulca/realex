require 'rio'
require 'digest/sha1'
require 'hpricot'
require 'net/https'
require 'builder'
 
$:.unshift(File.dirname(__FILE__))
require 'real_ex/initializer'
require 'real_ex/config'
require 'real_ex/client'

require 'real_ex/address'
require 'real_ex/card'
require 'real_ex/transaction'
require 'real_ex/response'
 
module RealEx
  class UnknownError < StandardError; end
 
  SourceName = 'twittergem'
end
