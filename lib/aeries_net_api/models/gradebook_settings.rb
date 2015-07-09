module AeriesNetApi
  module Models
    # Class to represent Gradebook Settings information extracted from Aeries site.
    class GradebookSettings < AeriesNetApi::Models::BaseModel
      # List of attributes to be extracted from Aeries site.
      @@aeries_attributes_list = %w(GradebookNumber CountCompletedNow DoingWeight ApplyRangeToStudent ShowLo ShowMinDate
                                    ShowHi ShowMaxDate FilterAssignmentsBy CountLo CountHi CountMinDate CountMaxDate
                                    ShowFinalMark DoingFormativeSummativeWeight FormativePercentage SummativePercentage
                                    DoingRubric DoingMinMaxAssignmentValues MinAssignmentValue MaxAssignmentValue)

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
        self.show_min_date = DateTime.parse(show_min_date) unless show_min_date.nil?
        self.show_max_date = DateTime.parse(show_max_date) unless show_max_date.nil?
        self.count_min_date = DateTime.parse(count_min_date) unless count_min_date.nil?
        self.count_max_date = DateTime.parse(count_max_date) unless count_max_date.nil?
      end
    end
  end
end
