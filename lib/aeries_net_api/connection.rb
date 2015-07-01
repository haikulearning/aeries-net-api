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

    #ToDo: Transform terms into an array of Term when this class be done.
    # Get school(s) information.
    # Parameters:
    # school_code  - optional.  If not given info for all schools will be retrieved.

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

    def terms(school_code)
      data=get_data("api/v2/schools/#{school_code}/terms")
      models=[]
      data.each do |item_data|
        models << AeriesNetApi::Models::Term.new(item_data)
      end
      models
    end


    private

    def get_data(endpoint)
      response=@connection.get do |req|
        req.url endpoint
      end
      raise "Error #{response.status} accessing Aeries site #{response.body}" unless response.status==200
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