# ToDo: Create documentation
# ToDo: Create tests

module AeriesNetApi
  module Models
    class School < AeriesNetApi::Models::BaseModel
#ToDo: make sure that this code executes just once.  Looks like only runs when class is first instantiated
      @@aeries_attributes_list= %w{SchoolCode Name InactiveStatusCode Address AddressCity AddressState AddressZipCode AddressZipExt DoNotReport StateCountyID StateDistrictID
           StateSchoolID LowGradeLevel HighGradeLevel Terms}

      @@setters_list = self.process_aeries_attributes(@@aeries_attributes_list)

      puts "executing ****"
      # ToDo: End of code to test for running once.

      def initialize(aeries_data=nil)
        parse(aeries_data, @@aeries_attributes_list, @@setters_list) if aeries_data.present?
      end

      # Overrides 'inspect' method to show only created attributes
      def inspect
        model_inspect(@@setters_list)
      end

      def attributes
        model_attributes(@@setters_list)
      end

    end
  end
end