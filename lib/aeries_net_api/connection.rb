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
    # :certificate  - (Optional) Aeries security certficate
    # :url          - (Optional)Aeries REST API url.
    # Any other  parameter raises an error.
    # If any of these parameters is missing, program looks for configuration file 'aeries_net_api_config.yml'
    # in current working directory and loads parameters from keys 'url' and/or 'certificate'
    def initialize(connection_parameters={})

      self.aeries_certificate=connection_parameters.delete(:certificate)
      self.aeries_url=connection_parameters.delete(:url)
      raise ArgumentError, "Invalid parameter(s): #{connection_parameters.keys.join(', ')}" if connection_parameters.any?
      load_configuration_file if self.aeries_certificate.blank? || self.aeries_url.blank?
      raise ArgumentError, 'Please supply :certificate parameter' if aeries_certificate.nil?
      raise ArgumentError, 'Please supply :url parameter' if aeries_url.nil?
      @connection = Faraday::Connection.new(self.aeries_url, :headers => {:'AERIES-CERT' => aeries_certificate,
                                                                          :accept => 'application/json, text/html, application/xhtml+xml, */*'}, :ssl => {:verify => false})
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
      unless school_code.nil?
        model=AeriesNetApi::Models::School.new(data)
      else
        models=[]
        data.each do |school_data|
          models << AeriesNetApi::Models::School.new(school_data)
        end
        models
      end
    end

    # Get terms for a given school
    # Parameters:
    # school_code - required.  The Aeries School Code. This is normally 1-999.
    #
    # Returns an array of Term objects.
    def terms(school_code)
      data=get_data("api/v2/schools/#{school_code}/terms")
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
    def students(school_code,student_id=nil)
      data=get_data("api/schools/#{school_code}/students/#{student_id}")
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
    # Returns an array or Contact
    def contacts(school_code,student_id=nil)
      data=get_data("api/schools/#{school_code}/contacts/#{student_id}")
      models=[]
      data.each do |item_data|
        models << AeriesNetApi::Models::Contact.new(item_data)
      end
      models
    end

    private

    def get_data(endpoint)
      response=@connection.get do |req|
        req.url endpoint
      end
      raise "Error #{response.status} accessing Aeries site: #{response.body}" unless response.status==200
      raise "Invalid response type received: #{response.headers["content-type"]}" unless response.headers["content-type"].match /json/
      JSON.parse(response.body)
    end

    # Load parameters from configuration file 'aeries_net_api_config.yml'.  File must be located in working directory.
    # Configuration parameters:
    # certificate - Aeries certificate, case sensitive
    # url         - Aeries
    def load_configuration_file
      begin
        raw_config = File.read(File.join(Dir.pwd, AeriesNetApi::Connection::CONFIGURATION_FILE))
      rescue Errno::ENOENT => e
        raise "Couldn't read configuration file #{AeriesNetApi::Connection::CONFIGURATION_FILE}: #{e.message}"
      end
      config = YAML.load(raw_config)
      self.aeries_certificate=config['certificate'] if self.aeries_certificate.blank?
      self.aeries_url=config['url'] if self.aeries_url.blank?
    end
  end
end