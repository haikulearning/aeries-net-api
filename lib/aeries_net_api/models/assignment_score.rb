module AeriesNetApi
  module Models

    # Class to represent AssignmentScore information extracted from Aeries site.
    class AssignmentScore < AeriesNetApi::Models::BaseModel

      # List of attributes to be extracted from Aeries site.
      @@aeries_attributes_list= %w{PermanentID GradebookNumber AssignmentNumber DateCompleted IsMissing PointsPossible
        PointsEarned NumberCorrectPossible NumberCorrect Mark PercentCorrect RuleNumberApplied IsRuleReplacingScore
        RuleReplacedScore StandardScores}

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

      # Overrides parse to parse dates, create StandardScore objects array
      def parse(aeries_data, aeries_attributes_list, setters_list)
        super
        self.date_completed=DateTime.parse(self.date_completed) unless self.date_completed.nil?
        standards_list=[]
        self.standard_scores.each do |item|
          standards_list << AeriesNetApi::Models::AssignmentStandardScore.new(item)
        end
        self.standard_scores=standards_list
      end
    end
  end
end