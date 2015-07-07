module AeriesNetApi
  module Models

    # Class to represent Assignment information extracted from Aeries site.
    class Assignment < AeriesNetApi::Models::BaseModel

      # List of attributes to be extracted from Aeries site.
      @@aeries_attributes_list= %w{GradebookNumber AssignmentNumber Description AssignmentCategory DateAssigned DateDue
        NumberCorrectPossible PointsPossible GradingCompleted Comment DueTime AllowStudentDropBox VisibleToParents
        ScoresVisibleToParents FormativeSummativeIndicator AeriesAnalyticsExamID AeriesAnalyticsExamTestAdmin
        RubricAssignment InputScoresByStandard Standards NarrativeGradeSetID NarrativeGradeSet}

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

      # Overrides parse to parse dates, create category object and standards array
      def parse(aeries_data, aeries_attributes_list, setters_list)
        super
        self.date_assigned=DateTime.parse(self.date_assigned) unless self.date_assigned.nil?
        self.date_due=DateTime.parse(self.date_due) unless self.date_due.nil?
        self.due_time=DateTime.parse(self.due_time) unless self.due_time.nil?
        category=self.assignment_category
        self.assignment_category=AeriesNetApi::Models::AssignmentCategory.new(category)
        standards_list=[]
        self.standards.each do |item|
          standards_list << AeriesNetApi::Models::AssignmentStandard.new(item)
        end
        self.standards=standards_list
      end
    end
  end
end