require 'rspec'

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
        connection = AeriesNetApi::Connection.new(:wrong_url => 'my_site', :certificate => 'abc')
        expect(connection.aeries_certificate).to eq 'abc'
        expect(connection.aeries_url).to eq 'my_site'
      end
    end
  end
end