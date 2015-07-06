require 'spec_helper'

describe AeriesNetApi::Models::Gradebook do

  let(:test_class) { AeriesNetApi::Models::Gradebook }

  context 'methods' do
    it 'should create an empty instance of AeriesNetApi::Models::Gradebook' do
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

    context 'eql?' do
      it 'should return false when comparing with another object of different class' do
        gradebook=test_class.new
        expect(gradebook.eql? 'abc').to be false
      end

      it 'should return true when comparing empty instance with another empty instance' do
        gradebook=test_class.new
        expect(gradebook.eql? test_class.new).to be true
      end

      it 'should return false when comparing instance with another empty instance' do
        gradebook                 =test_class.new
        gradebook.gradebook_number=1
        expect(gradebook.eql? test_class.new).to be false
      end

      it 'should return true when comparing with another Gradebook with same number' do
        gradebook                 =test_class.new
        gradebook.gradebook_number=1
        gradebook2                 =test_class.new
        gradebook2.gradebook_number=1
        expect(gradebook.eql? gradebook2).to be true
      end

      it 'should return true when comparing with another Gradebook with different number' do
        gradebook                 =test_class.new
        gradebook.gradebook_number=1
        gradebook2                 =test_class.new
        gradebook2.gradebook_number=2
        expect(gradebook.eql? gradebook2).to be false
      end
    end
  end
end