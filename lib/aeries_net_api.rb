require "aeries_net_api/version"
require 'aeries_net_api/connection'
require 'aeries_net_api/support'
require 'aeries_net_api/models/base_model'
require 'aeries_net_api/models/school'

module AeriesNetApi
  # Your code goes here...
end

class Object
 include AeriesNetApi::Support unless self.respond_to?(:blank?)
end