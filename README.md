# aeries_net_api
A ruby gem for connecting to the [Aeries.net API](http://www.aeries.com/downloads/docs.1234/TechnicalSpecs/Aeries_API_Documentation.pdf)

### Usage:

1. Create an instance of **AeriesNetApi::Connection**.  This class constructor expects a hash with optional parameters
**certificate** and/or **url**.  See AeriesNetApi::Connection#new for debug options.
If any of these parameters is missing, class looks for configuration file **'aeries_net_api_config.yml'**
in current working directory and loads parameters from keys 'url' and/or 'certificate'

1. Call methods from connection instance to get instances or arrays from different AeriesNetApi::Models, that correspond to information
retrieved from Aeries API endpoints.  See AeriesNetApi::Connection for a list of methods.

**Note:**
For Ruby versions prior to 1.9.3, [json](https://rubygems.org/gems/json) gem must be installed.
