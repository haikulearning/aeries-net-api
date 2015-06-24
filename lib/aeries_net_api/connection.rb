# Main class
module AeriesNetApi
  class Connection
    attr_accessor :aeries_certificate

    attr_accessor :aeries_url

    # Creates a new connection to Aeries site and optionally pass  connection parameters
    #
    def initialize(connection_parameters={})
      load_configuration_file and return unless connection_parameters.any?
      self.aeries_certificate=connection_parameters.delete(:certificate)
      self.aeries_url=connection_parameters.delete(:url)
      raise ArgumentError, "Invalid parameter(s): #{connection_parameters.keys.join(', ')}" if connection_parameters.any?
      raise ArgumentError, 'Please supply :certificate parameter' if aeries_certificate.nil?
      raise ArgumentError, 'Please supply :url parameter' if aeries_url.nil?
    end
  end

  private
  def load_configuration_file

  end
end