module AeriesNetApi
  module Update
    # Class to represent information to be sent to Aeries to update Gradebook Assignment Scores
    class AssignmentScoreUpdate
      # Student District Permanent ID Number.<br>
      # Type: Unsigned integer
      attr_accessor :permanent_id

      # The number of questions (or points) earned on this assignment. Do not populate
      # if standard_scores are being sent.<br>
      # Type: Signed decimal. Handles up to 4 decimal places
      attr_accessor :number_correct

      # Only populate if you really want to put in a specific value.
      # Otherwise, Aeries will automatically use the Due Date of the assignment.<br>
      # Type: Date
      attr_accessor :date_completed

      # Type: Array of AeriesNetApi::Update::AssignmentStandardScoreUpdate objects
      attr_accessor :standard_scores

      # Creates a new instance
      # [Parameters]
      # - Hash with these optional keys: permanent_id, number_correct, date_completed, standard_scores
      def initialize(attributes = {})
        self.permanent_id    = attributes.delete(:permanent_id)
        self.number_correct  = attributes.delete(:number_correct)
        self.date_completed  = attributes.delete(:date_completed)
        self.standard_scores = attributes.delete(:standard_scores) || []
        raise ArgumentError, "Invalid parameter(s) received: #{attributes.keys.join(', ')}" unless attributes.empty?
      end

      # Overrides to_json method to use Aeries name for objects
      def to_json(_options = {})
        json_hash = { 'PermanentId' => permanent_id }
        json_hash['NumberCorrect'] = number_correct unless number_correct.nil?
        json_hash['DateCompleted'] = date_completed.to_s unless date_completed.nil?
        json_hash['StandardScores'] = standard_scores
        json_hash.to_json
      end
    end
  end
end
