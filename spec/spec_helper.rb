$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'aeries_net_api'

RSpec.configure do |c|
  c.add_setting :aeries_certificate
  c.aeries_certificate='477abe9e7d27439681d62f4e0de1f5e1'
  c.add_setting :aeries_url
  c.aeries_url='https://demo.aeries.net/aeries.net/'
end
