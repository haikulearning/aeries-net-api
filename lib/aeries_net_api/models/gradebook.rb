module AeriesNetApi
  module Models
    # Class to represent Gradebook information extracted from Aeries site.
    class Gradebook < AeriesNetApi::Models::BaseModel
      # List of attributes to be extracted from Aeries site.
      @@aeries_attributes_list = %w(GradebookNumber SchoolCode TeacherNumber TeacherName TeacherEmailAddress Name Period
                                    StartDate EndDate Commment LinkedGroup GradebookType LastBackedUp Settings
                                    AssignmentCategories Sections Terms)

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

      # Overrides 'parse' method to parse dates, settings, categories, section
      def parse(aeries_data, aeries_attributes_list, setters_list)
        super
        self.start_date = DateTime.parse(start_date) unless start_date.nil?
        self.end_date = DateTime.parse(end_date) unless end_date.nil?
        self.last_backed_up = DateTime.parse(last_backed_up) unless last_backed_up.nil?
        self.settings = AeriesNetApi::Models::GradebookSettings.new(settings)
        categories = []
        assignment_categories.each do |category|
          categories << AeriesNetApi::Models::AssignmentCategory.new(category)
        end
        self.assignment_categories = categories
        sections = []
        self.sections.each do |section|
          sections << AeriesNetApi::Models::GradebookSection.new(section)
        end
        self.sections = sections
        terms = []
        self.terms.each do |term|
          terms << AeriesNetApi::Models::GradebookTerm.new(term)
        end
        self.terms = terms
      end

      def eql?(other)
        return false unless other.instance_of?(self.class)
        gradebook_number.eql? other.gradebook_number
      end
    end
  end
end
