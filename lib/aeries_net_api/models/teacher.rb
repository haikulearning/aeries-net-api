module AeriesNetApi
  module Models
    # Class to represent Teacher information extracted from Aeries site.
    class Teacher < AeriesNetApi::Models::BaseModel
      # List of attributes to be extracted from Aeries site.
      @@aeries_attributes_list = %w(SchoolCode TeacherNumber DisplayName FirstName LastName Room EmailAddress StaffID1
                                    StaffID2 StaffID3 StateCourseCode InactiveStatusCode HighlyQualifiedStatusCode1
                                    HighlyQualifiedStatusCode2 HighlyQualifiedStatusCode3)

      # List of methods to be used to create object's attributes dynamically.
      @@setters_list = process_aeries_attributes(@@aeries_attributes_list)

      # Creates a new object from data received from Aeries site.  It creates a new empty object if no data is received.
      def initialize(aeries_data = nil)
        parse(aeries_data, @@aeries_attributes_list, @@setters_list) if aeries_data.present?
      end

      # Overrides 'inspect' method to show only created attributes
      def inspect
        model_inspect(@@setters_list)
      end

      # Returns a hash of attributes extracted from Aeries site
      def attributes
        model_attributes(@@setters_list)
      end
    end
  end
end
