require 'spec_helper'

describe AeriesNetApi::Models::GradebookSettings do

 let(:test_class) {AeriesNetApi::Models::GradebookSettings}

  context 'methods' do
    it 'should create an empty instance of AeriesNetApi::Models::GradebookSettings' do
      expect(test_class.new).to be_instance_of test_class
    end

    it 'attributes should  return  a list of Aeries attributes' do
      object=test_class.new
      expect(object.attributes).to be_instance_of Hash
    end

    it 'inspect should return a string describing object' do
      object=test_class.new
      expect(object.inspect).to be_instance_of String
      expect(object.inspect).to be_include test_class.name
    end
  end
end