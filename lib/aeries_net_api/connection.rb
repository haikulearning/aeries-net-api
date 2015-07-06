# Main class
require 'yaml'
require 'faraday'
require 'json'

module AeriesNetApi
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
    def initialize(connection_parameters={})

      self.aeries_certificate=connection_parameters.delete(:certificate)
      self.aeries_url        =connection_parameters.delete(:url)
      raise ArgumentError, "Invalid parameter(s): #{connection_parameters.keys.join(', ')}" if connection_parameters.any?
      load_configuration_file if self.aeries_certificate.blank? || self.aeries_url.blank?
      raise ArgumentError, 'Please supply :certificate parameter' if aeries_certificate.nil?
      raise ArgumentError, 'Please supply :url parameter' if aeries_url.nil?
      @connection = Faraday::Connection.new(self.aeries_url, :headers => { :'AERIES-CERT' => aeries_certificate,
                                                                           :accept        => 'application/json, text/html, application/xhtml+xml, */*' }, :ssl => { :verify => false })
    end

    # Get school(s) information.
    # Parameters:
    # school_code  - optional.  The Aeries School Code. This is normally 1-999.  If School Code is not passed,
    # all schools for the current district will be returned.
    # School object contains a list of Terms.
    #
    # Returns:
    # - A single School object if school_code was given
    # - An array of School objects if school_code was omitted.
    def schools(school_code=nil)
      data=get_data("api/v2/schools/#{school_code}")
      if school_code.nil?
        models=[]
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
      data  =get_data("api/v2/schools/#{school_code}/terms")
      models=[]
      data.each do |item_data|
        models << AeriesNetApi::Models::Term.new(item_data)
      end
      models
    end

    # Get student(s) for a given school
    # Parameters:
    # school_code - required.  The Aeries School Code. This is normally 1-999.
    # student_id  - optional. The Aeries District Permanent ID Number.  If it is not passed, all students for the given
    # school will be returned.
    #
    # Returns array of Student.
    # Results are always returned in the form of an array because often students have multiple
    # records in a district if they are concurrently enrolled or have switched between schools during the school year.
    def students(school_code, student_id=nil)
      data  =get_data("api/schools/#{school_code}/students/#{student_id}")
      models=[]
      data.each do |item_data|
        models << AeriesNetApi::Models::Student.new(item_data)
      end
      models
    end

    # Get student contacts for a given student/school
    # Parameters:
    # school_code - required.  The Aeries School Code. This is normally 1-999.
    # student_id  - optional. The Aeries District Permanent ID Number.  If it is not passed, all contacts for all
    # students for the given school will be returned.
    #
    # Returns an array of Contact
    def contacts(school_code, student_id=nil)
      data  =get_data("api/schools/#{school_code}/contacts/#{student_id}")
      models=[]
      data.each do |item_data|
        models << AeriesNetApi::Models::Contact.new(item_data)
      end
      models
    end

    # Get student classes for a given student/school
    # Parameters:
    # school_code - required.  The Aeries School Code. This is normally 1-999.
    # student_id  - optional. The Aeries District Permanent ID Number.  If it is not passed, all classes for all
    # students for the given school will be returned.
    #
    # Returns an array of StudentClass
    def classes(school_code, student_id=nil)
      data  =get_data("api/schools/#{school_code}/classes/#{student_id}")
      models=[]
      data.each do |item_data|
        models << AeriesNetApi::Models::StudentClass.new(item_data)
      end
      models
    end

    # Get course(s) information.
    # Parameters:
    # course_id - optional.  The Aeries Course ID (alpha-numeric). If it is not passed, all courses in the district
    # will be returned.
    #
    # Returns:
    # - A single Course object if course_id was given
    # - An array of Course objects if course_id was omitted.
    def courses(course_id=nil)
      data=get_data("api/courses/#{course_id}")
      if course_id.present?
        AeriesNetApi::Models::Course.new(data)
      else
        models=[]
        data.each do |course_data|
          models << AeriesNetApi::Models::Course.new(course_data)
        end
        models
      end
    end

    # Get staff information.
    # Parameters:
    # staff_id - optional.  The Aeries District Staff ID (numeric).  If it is not passed, all staff records in
    # the district will be returned.
    #
    # Returns:
    # - A single Staff object if staff_id was given
    # - An array of Staff objects if staff_id was omitted.
    def staff(staff_id=nil)
      data=get_data("api/v2/staff/#{staff_id}")
      if staff_id.present?
        raise ArgumentError, "Staff member with id #{staff_id} doesn't exist" if data.blank?
        AeriesNetApi::Models::Staff.new(data.first)  # This endpoint always returns an array.
      else
        models=[]
        data.each do |member_data|
          models << AeriesNetApi::Models::Staff.new(member_data)
        end
        models
      end
    end

    # Get teacher(s) for a given school
    # Parameters:
    # school_code - required.  The Aeries School Code. This is normally 1-999.
    # teacher_number  - optional. The School-Based Aeries Teacher Number.
    #
    # Returns
    # - A single Teacher object if teacher_number was given
    # - An array of Teacher objects if teacher_number was omitted.
    def teachers(school_code, teacher_number=nil)
      data = get_data("api/schools/#{school_code}/teachers/#{teacher_number}")
      if teacher_number.nil?
        models=[]
        data.each do |school_data|
          models << AeriesNetApi::Models::Teacher.new(school_data)
        end
        models
      else
        AeriesNetApi::Models::Teacher.new(data)
      end
    end

    # Get section(s) for a given school
    # Parameters:
    # school_code - required.  The Aeries School Code. This is normally 1-999.
    # section_number  - optional. The School-Based Aeries Section Number.
    #
    # Returns
    # - A single Section object if section_number was given
    # - An array of Section objects if section_number was omitted.
    def sections(school_code, section_number=nil)
      data = get_data("api/schools/#{school_code}/sections/#{section_number}")
      # puts data.keys.join(' ')  if data.present? && section_number.present? # To extract current Aeries attributes names
      if section_number.nil?
        models=[]
        data.each do |school_data|
          models << AeriesNetApi::Models::Section.new(school_data)
        end
        models
      else
        AeriesNetApi::Models::Section.new(data)
      end
    end
    private

    def get_data(endpoint)
      response=@connection.get do |req|
        req.url endpoint
        req.options.timeout      = 120 # read timeout in seconds
        req.options.open_timeout = 60 # open timeout in seconds
      end
      raise "Error #{response.status} accessing Aeries site: #{response.body}" unless response.status==200
      raise "Invalid response type received: #{response.headers['content-type']}" unless response.headers['content-type'].match /json/
      JSON.parse(response.body)
    end

    # Load parameters from configuration file 'aeries_net_api_config.yml'.  File must be located in working directory.
    # Configuration parameters:
    # certificate - Aeries certificate, case sensitive
    # url         - Aeries
    def load_configuration_file
      begin
        raw_config             = File.read(File.join(Dir.pwd, AeriesNetApi::Connection::CONFIGURATION_FILE))
        config                 = YAML.load(raw_config)
        self.aeries_certificate=config['certificate'] if self.aeries_certificate.blank?
        self.aeries_url        =config['url'] if self.aeries_url.blank?
      rescue Errno::ENOENT => e
        raise "Couldn't read configuration file #{AeriesNetApi::Connection::CONFIGURATION_FILE}: #{e.message}"
      end
    end
  end
end