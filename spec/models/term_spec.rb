require 'spec_helper'

describe AeriesNetApi::Models::Term do

 let(:test_class) {AeriesNetApi::Models::Term}

  context 'methods' do
    it 'should create an instance of AeriesNetApi::Models::Term' do
      expect(test_class.new).to be_instance_of test_class
    end

    it 'attributes should  return  a list of Aeries attributes' do
      school=test_class.new
      expect(school.attributes).to be_instance_of Hash
    end

    it 'inspect should return a string describing object' do
      school=test_class.new
      expect(school.inspect).to be_instance_of String
      expect(school.inspect).to be_include test_class.name
    end
  end
end