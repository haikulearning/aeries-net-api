# Main class
require 'yaml'
require 'faraday'
require 'json'

module AeriesNetApi
  class Connection

    CONFIGURATION_FILE = 'aeries_net_api_config.yml'
    attr_accessor :aeries_certificate, :aeries_url

    # Creates a new connection to Aeries site and optionally pass  connection parameters
    # ToDo:  Create documentation
    def initialize(connection_parameters={})

      self.aeries_certificate=connection_parameters.delete(:certificate)
      self.aeries_url=connection_parameters.delete(:url)
      raise ArgumentError, "Invalid parameter(s): #{connection_parameters.keys.join(', ')}" if connection_parameters.any?
      load_configuration_file if self.aeries_certificate.blank? || self.aeries_url.blank?
      raise ArgumentError, 'Please supply :certificate parameter' if aeries_certificate.nil?
      raise ArgumentError, 'Please supply :url parameter' if aeries_url.nil?
      @connection = Faraday::Connection.new(self.aeries_url,:headers => {:'AERIES-CERT' => aeries_certificate,
         :accept => 'application/json, text/html, application/xhtml+xml, */*'}, :ssl => {:verify => false})
    end

    #ToDo: Create array of School when no School code is given
    #ToDo: Transform terms into an array of Term when this class be done.
    def schools(school_code=nil)
      data=get_data("api/v2/schools/#{school_code}")
      puts data
      unless school_code.nil?
        model=AeriesNetApi::Models::School.new(data)
      else
        schools=[]
      end
    end

    private

    def get_data(endpoint)
      response=@connection.get do |req|
        req.url endpoint
      end
      raise "Error #{response.status} accessing Aeries site" unless response.success?
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