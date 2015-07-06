require "aeries_net_api/version"
require 'aeries_net_api/connection'
require 'aeries_net_api/support'
require 'aeries_net_api/models/base_model'
require 'aeries_net_api/models/school'
require 'aeries_net_api/models/term'
require 'aeries_net_api/models/student'
require 'aeries_net_api/models/contact'
require 'aeries_net_api/models/student_class'
require 'aeries_net_api/models/course'
require 'aeries_net_api/models/staff'
require 'aeries_net_api/models/teacher'
require 'aeries_net_api/models/section'

module AeriesNetApi

end

# Add required methods unless already defined (maybe running under Rails?)
class Object
 include AeriesNetApi::Support unless self.respond_to?(:blank?)
end