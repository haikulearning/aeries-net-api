module AeriesNetApi
  module Models

    # Class to represent School information extracted from Aeries site.
    class Term < AeriesNetApi::Models::BaseModel

      # List of attributes to be extracted from Aeries site.
      @@aeries_attributes_list= %w{TermCode TermDescription StartDate EndDate}

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
        self.start_date=DateTime.parse(self.start_date) unless self.start_date.nil?
        self.end_date=DateTime.parse(self.end_date) unless self.end_date.nil?
      end

    end
  end
end