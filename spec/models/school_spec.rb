require 'spec_helper'

describe AeriesNetApi::Models::School do

  context 'methods' do

    it 'should create an empty instance of AeriesNetApi::Models::School' do
      expect(AeriesNetApi::Models::School.new).to be_instance_of AeriesNetApi::Models::School
    end

    it 'attributes should  return  a list of Aeries attributes' do
      school=AeriesNetApi::Models::School.new
      expect(school.attributes).to be_instance_of Hash
    end

    it 'inspect should return a string describing object' do
      school=AeriesNetApi::Models::School.new
      expect(school.inspect).to be_instance_of String
      expect(school.inspect).to be_include 'AeriesNetApi::Models::School'
    end
  end
end