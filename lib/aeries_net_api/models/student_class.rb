module AeriesNetApi
  module Models

    # Class to represent StudentClass information extracted from Aeries site.
    class StudentClass < AeriesNetApi::Models::BaseModel

      # List of attributes to be extracted from Aeries site.
      @@aeries_attributes_list= %w{PermanentID SchoolCode SequenceNumber CourseID SectionNumber Period PeriodBlock
        TeacherNumber DateStarted DateEnded}

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
        self.date_started=DateTime.parse(self.date_started) unless self.date_started.nil?
        self.date_ended=DateTime.parse(self.date_ended) unless self.date_ended.nil?
      end

    end
  end
end