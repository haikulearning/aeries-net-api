module AeriesNetApi
  module Models

    # Class to represent School information extracted from Aeries site.
    class School < AeriesNetApi::Models::BaseModel
#ToDo: make sure that this code executes just once.  Looks like only runs when class is first instantiated

      # List of attributes to be extracted from Aeries site.
      @@aeries_attributes_list= %w{SchoolCode Name InactiveStatusCode Address AddressCity AddressState AddressZipCode AddressZipExt DoNotReport StateCountyID StateDistrictID
           StateSchoolID LowGradeLevel HighGradeLevel Terms}

      # List of methods to be used to create object's attributes dynamically.
      @@setters_list = self.process_aeries_attributes(@@aeries_attributes_list)

      puts "executing ****"
      # ToDo: End of code to test for running once.

      # Creates a new object from data received from Aeries site.  It creates a new empty object if no data is received.
      def initialize(aeries_data=nil)
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