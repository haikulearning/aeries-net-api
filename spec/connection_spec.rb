require 'rspec'
# ToDo: add specs to test handling of response errors.
# ToDo: add specs to test connectivity

describe AeriesNetApi::Connection do

  describe 'constructor' do
    context 'right parameters' do
      it 'should set connection parameters' do
        connection = AeriesNetApi::Connection.new(:url => 'my_site', :certificate => 'abc')
        expect(connection.aeries_certificate).to eq 'abc'
        expect(connection.aeries_url).to eq 'my_site'
      end
    end

    context 'wrong parameters' do
      it 'should raise an error for invalid parameters' do
        expect { AeriesNetApi::Connection.new(:wrong_url => 'my_site', :certificate => 'abc') }.to raise_error(ArgumentError)
      end
    end

    context 'missing parameters' do
      it 'should raise an error if config file can\'t be found' do
        allow(Dir).to receive(:pwd) { 'non_existent_directory' }
        expect { AeriesNetApi::Connection.new() }.to raise_error(RuntimeError)
      end

      it 'should read url parameter from configuration file if not received' do
        connection = AeriesNetApi::Connection.new(:certificate => 'abc')
        expect(connection.aeries_certificate).to be_eql 'abc'
        expect(connection.aeries_url).not_to be_empty
      end

      it 'should read certificate parameter from configuration file if not received' do
        connection = AeriesNetApi::Connection.new(:url => 'my_site')
        expect(connection.aeries_certificate).not_to be_empty
        expect(connection.aeries_url).to be_eql 'my_site'
      end
    end
  end

  describe 'methods' do

    let(:connection) { AeriesNetApi::Connection.new(:certificate => RSpec.configuration.aeries_certificate, :url => RSpec.configuration.aeries_url) }
    it 'should include a schools method' do
      expect(connection.respond_to?(:schools)).to be true
    end
    context 'school' do
      it 'should return school information for a given id' do
        expect(connection.schools(1)).to be_an_instance_of(AeriesNetApi::Models::School)
      end

      it 'should return a list of schools when an id was not given' do
        schools=connection.schools()
        expect(schools).to be_an_instance_of(Array)
        expect(schools.first).to be_an_instance_of(AeriesNetApi::Models::School)
      end
    end
  end
end