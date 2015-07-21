# aeries_net_api
A ruby gem for connecting to the Aeries.net API.

###Usage:

1. Create an instance of <b>AeriesNetApi::Connection</b>.  This class constructor expects a hash with optional parameters
<b>certificate</b> and/or <b>url</b>.
If any of these parameters is missing, class looks for configuration file <b>'aeries_net_api_config.yml'</b>
in current working directory and loads parameters from keys 'url' and/or 'certificate'

1. Call methods from connection instance to get instances or arrays from different AeriesNetApi::Models, that correspond to information
retrieved from Aeries API endpoints.  See AeriesNetApi::Connection for a list of methods.

Note:
For Ruby versions prior to 1.9.3, json gem must be installed.
