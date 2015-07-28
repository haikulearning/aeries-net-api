module AeriesNetApi
  # Models used for update.
  module Update
    # Class to represent information to be sent to Aeries to update Gradebook Assignment Standard Scores
    class AssignmentStandardScoreUpdate
      # Either this field or the academic_benchmark_id field must be populated. This needs to match information originally
      # found in the "Assignment" object.<br>
      # Type: String
      attr_accessor :aeries_standard_id

      # Either this field or the aeries_standard_id field must be populated. This needs to match information originally
      # found in the "Assignment" object.<br>
      # Type: String
      attr_accessor :academic_benchmark_id

      # The number of questions (or points) earned on this standard, within the given assignment.<br>
      # Type: Signed Decimal. Handles up to 4 decimal places.
      attr_accessor :number_correct

      # Creates a new instance
      # [Parameters]
      # - Hash with these optional keys: aeries_standard_id, academic_benchmark_id, number_correct
      def initialize(attributes = {})
        self.aeries_standard_id     = attributes.delete(:aeries_standard_id)
        self.academic_benchmark_id  = attributes.delete(:academic_benchmark_id)
        self.number_correct         = attributes.delete(:number_correct)
        raise ArgumentError, "Invalid parameter(s) received: #{attributes.keys.join(', ')}" unless attributes.empty?
      end

      # Overrides to_json method to use Aeries name for objects
      def to_json(_options = {})
        json_hash = {}
        json_hash['AeriesStandardId'] = aeries_standard_id unless aeries_standard_id.nil?
        json_hash['AcademicBenchmarkId'] = academic_benchmark_id unless academic_benchmark_id.nil?
        json_hash['NumberCorrect'] = number_correct
        json_hash.to_json
      end
    end
  end
end
