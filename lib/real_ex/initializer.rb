module RealEx
  module Initializer
    
    def self.included(base)
      base.extend(ClassMethods)
    end

    # this blatantly ripped from jnunemaker's Twitter gem. Thanks John!
    module ClassMethods
      # creates the attributes class variable and creates each attribute's accessor methods
      def attributes(*attrs)
        @@attributes = attrs
        @@attributes.each { |a| attr_accessor a }
      end
      
      # read method for attributes class variable
      def self.attributes; @@attributes end
    end
    
    def initialize(setters = {})
      setters.each { |k, v| send("#{k}=", v) } unless setters.nil?
    end
  end
end
