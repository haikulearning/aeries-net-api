# Main class
require 'rubygems' if RUBY_VERSION < '1.9'
require 'yaml'
require 'faraday'
require 'json'

module AeriesNetApi
  # Class to interact with Aeries API.  It creates connection to Aeries site and send required REST requests.
  class Connection
    CONFIGURATION_FILE = 'aeries_net_api_config.yml'
    attr_accessor :aeries_certificate, :aeries_url

    # Creates a new connection to Aeries site.
    # Parameters
    # A hash with following parameters
    # :certificate  - (Optional) Aeries security certificate
    # :url          - (Optional)Aeries REST API url.
    # Any other  parameter raises an error.
    # If any of these parameters is missing, program looks for configuration file 'aeries_net_api_config.yml'
    # in current working directory and loads parameters from keys 'url' and/or 'certificate'
    def initialize(connection_parameters = {})
      self.aeries_certificate = connection_parameters.delete(:certificate)
      self.aeries_url         = connection_parameters.delete(:url)
      raise ArgumentError, "Invalid parameter(s): #{connection_parameters.keys.join(', ')}" if connection_parameters.any?
      load_configuration_file if aeries_certificate.blank? || aeries_url.blank?
      raise ArgumentError, 'Please supply :certificate parameter' if aeries_certificate.nil?
      raise ArgumentError, 'Please supply :url parameter' if aeries_url.nil?
      @connection =
          Faraday::Connection.new(aeries_url,
                                  :headers => { :'AERIES-CERT' => aeries_certificate,
                                                :accept        => 'application/json, text/html, application/xhtml+xml, */*' },
                                  :ssl     => { :verify => false })
    end

    # Get school(s) information.
    # Parameters:
    # school_code  - optional.  The Aeries School Code. This is normally 1-999.  If School Code is not passed,
    #                all schools for the current district will be returned.
    # School object contains a list of Terms.
    #
    # Returns:
    # - A single School object if school_code was given
    # - An array of School objects if school_code was omitted.
    def schools(school_code = nil)
      data = get_data("api/v2/schools/#{school_code}")
      if school_code.nil?
        models = []
        data.each do |school_data|
          models << AeriesNetApi::Models::School.new(school_data)
        end
        models
      else
        AeriesNetApi::Models::School.new(data)
      end
    end

    # Get terms for a given school
    # Parameters:
    # school_code - required.  The Aeries School Code. This is normally 1-999.
    #
    # Returns an array of Term objects.
    def terms(school_code)
      data   = get_data("api/v2/schools/#{school_code}/terms")
      models = []
      data.each do |item_data|
        models << AeriesNetApi::Models::Term.new(item_data)
      end
      models
    end

    # Get student(s) for a given school
    # Parameters:
    # school_code - required.  The Aeries School Code. This is normally 1-999.
    # student_id  - optional. The Aeries District Permanent ID Number.  If it is not passed, all students for the given
    #               school will be returned.
    #
    # Returns array of Student.
    # Results are always returned in the form of an array because often students have multiple
    # records in a district if they are concurrently enrolled or have switched between schools during the school year.
    def students(school_code, student_id = nil)
      data   = get_data("api/schools/#{school_code}/students/#{student_id}")
      models = []
      data.each do |item_data|
        models << AeriesNetApi::Models::Student.new(item_data)
      end
      models
    end

    # Get student contacts for a given student/school
    # Parameters:
    # school_code - required.  The Aeries School Code. This is normally 1-999.
    # student_id  - optional. The Aeries District Permanent ID Number.  If it is not passed, all contacts for all
    #               students for the given school will be returned.
    #
    # Returns an array of Contact
    def contacts(school_code, student_id = nil)
      data   = get_data("api/schools/#{school_code}/contacts/#{student_id}")
      models = []
      data.each do |item_data|
        models << AeriesNetApi::Models::Contact.new(item_data)
      end
      models
    end

    # Get student classes for a given student/school
    # Parameters:
    # school_code - required.  The Aeries School Code. This is normally 1-999.
    # student_id  - optional. The Aeries District Permanent ID Number.  If it is not passed, all classes for all
    #               students for the given school will be returned.
    #
    # Returns an array of StudentClass
    def classes(school_code, student_id = nil)
      data   = get_data("api/schools/#{school_code}/classes/#{student_id}")
      models = []
      data.each do |item_data|
        models << AeriesNetApi::Models::StudentClass.new(item_data)
      end
      models
    end

    # Get course(s) information.
    # Parameters:
    # course_id - optional.  The Aeries Course ID (alpha-numeric). If it is not passed, all courses in the district
    #             will be returned.
    #
    # Returns:
    # - A single Course object if course_id was given
    # - An array of Course objects if course_id was omitted.
    def courses(course_id = nil)
      data = get_data("api/courses/#{course_id}")
      if course_id.present?
        AeriesNetApi::Models::Course.new(data)
      else
        models = []
        data.each do |course_data|
          models << AeriesNetApi::Models::Course.new(course_data)
        end
        models
      end
    end

    # Get staff information.
    # Parameters:
    # staff_id - optional.  The Aeries District Staff ID (numeric).  If it is not passed, all staff records in
    #            the district will be returned.
    #
    # Returns:
    # - A single Staff object if staff_id was given
    # - An array of Staff objects if staff_id was omitted.
    def staff(staff_id = nil)
      data = get_data("api/v2/staff/#{staff_id}")
      if staff_id.present?
        raise ArgumentError, "Staff member with id #{staff_id} doesn't exist" if data.blank?
        AeriesNetApi::Models::Staff.new(data.first) # This endpoint always returns an array.
      else
        models = []
        data.each do |member_data|
          models << AeriesNetApi::Models::Staff.new(member_data)
        end
        models
      end
    end

    # Get teacher(s) for a given school
    # Parameters:
    # school_code     - required.  The Aeries School Code. This is normally 1-999.
    # teacher_number  - optional. The School-Based Aeries Teacher Number.
    #
    # Returns
    # - A single Teacher object if teacher_number was given
    # - An array of Teacher objects if teacher_number was omitted.
    def teachers(school_code, teacher_number = nil)
      data = get_data("api/schools/#{school_code}/teachers/#{teacher_number}")
      if teacher_number.nil?
        models = []
        data.each do |teacher_data|
          models << AeriesNetApi::Models::Teacher.new(teacher_data)
        end
        models
      else
        AeriesNetApi::Models::Teacher.new(data)
      end
    end

    # Get section(s) for a given school
    # Parameters:
    # school_code     - required.  The Aeries School Code. This is normally 1-999.
    # section_number  - optional. The School-Based Aeries Section Number.
    #
    # Returns
    # - A single Section object if section_number was given
    # - An array of Section objects if section_number was omitted.
    def sections(school_code, section_number = nil)
      data = get_data("api/schools/#{school_code}/sections/#{section_number}")
      if section_number.nil?
        models = []
        data.each do |section_data|
          models << AeriesNetApi::Models::Section.new(section_data)
        end
        models
      else
        AeriesNetApi::Models::Section.new(data)
      end
    end

    # Get class roster for a given section/school
    # Parameters:
    # school_code    - required.  The Aeries School Code. This is normally 1-999.
    # section_number - required. The School-Based Aeries Section Number.
    #
    # Returns
    # - An array of StudentClass objects.
    def class_roster(school_code, section_number)
      data   = get_data("api/v1/schools/#{school_code}/sections/#{section_number}/students")
      models = []
      data.each do |class_data|
        models << AeriesNetApi::Models::StudentClass.new(class_data)
      end
      models
    end

    # Get gradebooks for a given section/school
    # Parameters:
    # school_code    - required.  The Aeries School Code. This is normally 1-999.
    # section_number - required. The School-Based Aeries Section Number.
    #
    # Returns
    # - An array of Gradebook objects.
    def gradebooks(school_code, section_number)
      data   = get_data("api/v2/schools/#{school_code}/sections/#{section_number}/gradebooks")
      models = []
      data.each do |gradebook_data|
        models << AeriesNetApi::Models::Gradebook.new(gradebook_data)
      end
      models
    end

    # Get a gradebook for a given gradebook number
    # Parameters:
    # gradebook_number - required.  The specific Aeries Gradebook Number.
    #
    # Returns
    # - A Gradebook object.
    def gradebook(gradebook_number)
      data = get_data("api/v2/gradebooks/#{gradebook_number}")
      AeriesNetApi::Models::Gradebook.new(data)
    end

    # Get assignment(s) for a given gradebook/asignment number
    # Parameters:
    # gradebook_number  - required.  The specific Aeries Gradebook Number.
    # assignment_number - optional.  The specific Assignment Number. Returns all assignments for gradebook if omitted
    # Returns
    # - An array of Assignment objects if assignment number is omitted.
    # - An assignment object if assignment number is passed
    def assignments(gradebook_number, assignment_number = nil)
      data = get_data("api/v2/gradebooks/#{gradebook_number}/assignments/#{assignment_number}")
      if assignment_number.nil?
        models = []
        data.each do |assignment_data|
          models << AeriesNetApi::Models::Assignment.new(assignment_data)
        end
        models
      else
        raise "Assignment #{assignment_number} doesn't exist for gradebook #{gradebook_number}" if data.nil?
        AeriesNetApi::Models::Assignment.new(data)
      end
    end

    # Get final marks for a given gradebook number
    # Parameters:
    # gradebook_number - required.  The specific Aeries Gradebook Number.
    #
    # Returns
    # - An array of FinalMark objects.
    def final_marks(gradebook_number)
      data   = get_data("api/v2/gradebooks/#{gradebook_number}/FinalMarks")
      models = []
      # Aeries returns an array filled with nil for an invalid gradebook number
      return models if data.empty? || data.first.nil?
      data.each do |item_data|
        models << AeriesNetApi::Models::FinalMark.new(item_data)
      end
      models
    end

    # Get gpa(s) for a given school/student
    # Parameters:
    # school_code - required.  The Aeries School Code. This is normally 1-999.
    # student_id  - optional. The Aeries District Permanent ID Number.  If it is not passed, all gpa's for all
    #               students of the school will be returned.
    #
    # Returns array of GPA.
    # Results are always returned in the form of an array because often students have multiple
    # records in a district if they are concurrently enrolled or have switched between schools during the school year.
    def gpas(school_code, student_id = nil)
      data   = get_data("api/schools/#{school_code}/gpas/#{student_id}")
      # puts data.first.keys.join(' ') if data.present? # && section_number.present? # To extract current Aeries attributes names
      models = []
      data.each do |item_data|
        models << AeriesNetApi::Models::GPA.new(item_data)
      end
      models
    end

    # Get student programs for a given school/student
    # Parameters:
    # school_code - required.  The Aeries School Code. This is normally 1-999.
    # student_id  - optional (pass 0 for all students) The Aeries District Permanent ID Number.  If it is not passed
    #               or you pass a 0 (zero) instead, all programs for all students for the given school will be returned.
    #
    # Returns array of StudentProgram.
    def student_programs(school_code, student_id = nil)
      student_id ||= 0
      data       = get_data("api/v1/schools/#{school_code}/students/#{student_id}/programs")
      # puts data.first.keys.join(' ') if data.present? # && section_number.present? # To extract current Aeries attributes names
      models     = []
      data.each do |item_data|
        models << AeriesNetApi::Models::StudentProgram.new(item_data)
      end
      models
    end

    # Get code set information for a given table/field
    # Parameters:
    # table_code -  required.  The 3 character Aeries Table Code or the API Object name. If you know the 3
    #               character Aeries Table Code, feel free to use it. Otherwise, use the object name returned through the
    #               API. Examples include: "STU", "student", "CON", "contact", "course", "staff", "teacher", and "section" .
    # field_code -  required. The 2-4 character Aeries Field Code or the API Object name. If you know the 2-4
    #               character Aeries Field Code, feel free to use it. Otherwise, use the object name returned through the API.
    #               Examples include: "HL", "HomeLanguage", or "HomeLanguageCode". Fields/Properties in objects ending in "Code" have
    #               a code set associated with them. The "Field" passed to this end point can include the word "Code" or not.
    #
    # Returns array of Code.
    def codes(table_code, field_code)
      data   = get_data("api/codes/#{table_code}/#{field_code}")
      models = []
      data.each do |item_data|
        models << AeriesNetApi::Models::Code.new(item_data)
      end
      models
    end

    # Get student(s) for a given gradebook number/gradebook term
    # Parameters:
    # gradebook_number    - required.  The specific Aeries Gradebook Number.
    # gradebook_term_code - required.  The term code from the Gradebook object (Gradebook --> Terms --> Term Code)
    # student_id          - optional. The Aeries District Permanent ID Number.  If it is not passed, all students
    #                       for given gradebook/term will be returned.
    # Returns
    # - An array of GradebookStudent objects if student_id is ommited.
    # - A single GradebookStudent object if student_id is passed.
    def gradebooks_students(gradebook_number, gradebook_term_code, student_id = nil)
      data = get_data("api/v2/gradebooks/#{gradebook_number}/#{gradebook_term_code}/students/#{student_id}")
      if student_id.nil?
        models = []
        data.each do |item_data|
          models << AeriesNetApi::Models::GradebookStudent.new(item_data)
        end
        models
      else
        student = AeriesNetApi::Models::GradebookStudent.new(data)
        raise "Invalid student_id #{student_id} for gradebook #{gradebook_number}, " \
            "term code #{gradebook_term_code}" if student.permanent_id != student_id
        student
      end
    end

    # Get assignments scores for a given gradebook number/assignment_number
    # Parameters:
    # gradebook_number   - required. The specific Aeries Gradebook Number.
    # assignment_number  - required. The specific Assignment Number.
    #
    # Returns
    # An array of AssignmentScore objects.
    def assignments_scores(gradebook_number, assignment_number)
      data   = get_data("api/v2/gradebooks/#{gradebook_number}/assignments/#{assignment_number}/scores")
      models = []
      # puts data.first.keys.join(' ') if data.present? # && section_number.present? # To extract current Aeries attributes names
      data.each do |assignment_data|
        models << AeriesNetApi::Models::AssignmentScore.new(assignment_data)
      end
      models
    rescue => e
      # Trap error when an invalid gradebook_number or assignmen_number is given
      # Aeries is sending a 500 status error with a long description including following text.
      if e.message =~ /500/ && e.message =~ /Object reference not set to an instance of an object/
        [] # return a blank array
      else
        raise # raise trapped exception
      end
    end

    # Update assignments scores for a given gradebook number/assignment_number
    # Parameters:
    # gradebook_number    - required.  The specific Aeries Gradebook Number.
    # assignment_number   - required.  The specific Assignment Number.
    # assignment_scores   - required.  Array of AeriesNetApi::Update::AssignmentScoreUpdate
    # Returns
    # An array of AssignmentScore objects.
    def update_gradebook_scores(gradebook_number, assignment_number, assignment_scores)
      raise ArgumentError unless assignment_scores.is_a?(Array)
      assignment_scores.each_with_index do |item, i|
        raise ArgumentError, "Invalid element(#{i}) in array: #{item.inspect}, " \
        'it should be an AeriesNetApi::Update::AssignmentScoreUpdate object' unless \
         item.instance_of? AeriesNetApi::Update::AssignmentScoreUpdate
      end
      data   = post_data("api/v2/gradebooks/#{gradebook_number}/assignments/#{assignment_number}/UpdateScores", assignment_scores.to_json)
      models = []
      # puts data.first.keys.join(' ') if data.present? # && section_number.present? # To extract current Aeries attributes names
      data.each do |assignment_data|
        models << AeriesNetApi::Models::AssignmentScore.new(assignment_data)
      end
      models
    end

    private

    # Send request to Aeries site
    # Parameters:
    # endpoint    - Url to be used to request data
    #
    # Returns
    # A hash contained JSON data parsed.
    def get_data(endpoint)
      response = @connection.get do |req|
        req.url endpoint
        req.options[:timeout]      = 120 # read timeout in seconds
        req.options[:open_timeout] = 60 # open timeout in seconds
      end
      raise "Error #{response.status} accessing Aeries site: #{response.body}" unless response.status == 200
      raise "Invalid response type received: #{response.headers['content-type']}" unless response.headers['content-type'].match(/json/)
      JSON.parse(response.body)
    end

    # Post update data toAeries site
    # Parameters:
    # endpoint    - Url to be used to request data
    # body_content     - Body content of posted data.
    # Returns
    # ???
    def post_data(endpoint, body_content)
      response = @connection.post do |req|
        req.url endpoint
        req.options[:timeout]         = 120 # read timeout in seconds
        req.options[:open_timeout]    = 60 # open timeout in seconds
        req.headers['Content-Type'] = 'application/json'
        req.body                    = body_content
      end
      raise "Error #{response.status} accessing Aeries site: #{response.body}" unless response.status == 200
      raise "Invalid response type received: #{response.headers['content-type']}" unless response.headers['content-type'].match(/json/)
      JSON.parse(response.body)
    end

    # Load parameters from configuration file 'aeries_net_api_config.yml'.  File must be located in working directory.
    # Configuration parameters:
    # certificate - Aeries certificate, case sensitive
    # url         - Aeries
    def load_configuration_file
      raw_config              = File.read(File.join(Dir.pwd, AeriesNetApi::Connection::CONFIGURATION_FILE))
      config                  = YAML.load(raw_config)
      self.aeries_certificate = config['certificate'] if aeries_certificate.blank?
      self.aeries_url         = config['url'] if aeries_url.blank?
    rescue Errno::ENOENT => e
      raise "Couldn't read configuration file #{AeriesNetApi::Connection::CONFIGURATION_FILE}: #{e.message}"
    end
  end
end
