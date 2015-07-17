module AeriesNetApi
  module Models
    # Class to represent Staff information extracted from Aeries site.
    class Staff < AeriesNetApi::Models::BaseModel
      # List of attributes to be extracted from Aeries site.
      @@aeries_attributes_list = %w(ID FirstName LastName MiddleName Sex BirthYear BirthDate FullTimePercentage HireDate
                                    LeaveDate InactiveStatusCode StateEducatorID UserName EmailAddress
                                    PrimaryAeriesSchool)

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

      # Overrides 'parse' method to parse dates
      def parse(aeries_data, aeries_attributes_list, setters_list)
        super
        self.birth_date = DateTime.parse(birth_date) unless birth_date.nil?
        self.hire_date = DateTime.parse(hire_date) unless hire_date.nil?
        self.leave_date = DateTime.parse(leave_date) unless leave_date.nil?
      end
    end
  end
end
