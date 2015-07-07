module AeriesNetApi
  module Models

    # Class to represent Staff information extracted from Aeries site.
    class StudentProgram < AeriesNetApi::Models::BaseModel

      # List of attributes to be extracted from Aeries site.
      @@aeries_attributes_list= %w{StudentID ProgramCode ProgramDescription EligibilityStartDate EligibilityEndDate
        ParticipationStartDate ParticipationEndDate}

      # List of methods to be used to create object's attributes dynamically.
      @@setters_list = self.process_aeries_attributes(@@aeries_attributes_list)

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

      # Overrides 'parse' method to parse dates
      def parse(aeries_data, aeries_attributes_list, setters_list)
        super
        self.eligibility_start_date=DateTime.parse(self.eligibility_start_date) unless self.eligibility_start_date.nil?
        self.eligibility_end_date=DateTime.parse(self.eligibility_end_date) unless self.eligibility_end_date.nil?
        self.participation_start_date=DateTime.parse(self.participation_start_date) unless self.participation_start_date.nil?
        self.participation_end_date=DateTime.parse(self.participation_end_date) unless self.participation_end_date.nil?
      end
    end
  end
end