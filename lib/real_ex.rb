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
 
module RealEx
  class Unavailable < StandardError; end
  class CantConnect < StandardError; end
  class BadResponse < StandardError; end
  class UnknownTimeline < ArgumentError; end
  class RateExceeded < StandardError; end
  class CantFindUsers < ArgumentError; end
  class AlreadyFollowing < StandardError; end
  class CantFollowUser < StandardError; end
 
  SourceName = 'twittergem'
end
