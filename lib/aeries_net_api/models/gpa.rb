module AeriesNetApi
  module Models

    # Class to represent GPA information extracted from Aeries site.
    class GPA < AeriesNetApi::Models::BaseModel

      # List of attributes to be extracted from Aeries site.
      @@aeries_attributes_list= %w{PermanentID SchoolCode ClassRank ClassSize ClassRank1012 GPA_CumulativeAcademic
        GPA_CumulativeTotal GPA_CumulativeAcademic1012 GPA_CumulativeAcademicNonWeighted GPA_CumulativeTotalNonWeighted
        GPA_CumulativeAcademic1012NonWeighted GradePointsCumulative GPA_UC_Preliminary GPA_CSU_Preliminary
        GPA_CumulativeCitizenship GPA_GradeReportingCitizenship CreditsAttempted CreditsCompleted
        GPA_GradeReportingAcademic GPA_GradeReportingTotal GPA_GradeReportingAcademicNonWeighted
        GPA_GradeReportingTotalNonWeighted GradeReportingClassRank GradeReportingClassSize GradeReportingCreditsAttempted
        GradeReportingCreditsCompleted}

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
    end
  end
end