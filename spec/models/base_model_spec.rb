require 'spec_helper'

describe AeriesNetApi::Models::BaseModel do

  context 'underscore method' do

    it 'should include an underscore method' do
      expect(AeriesNetApi::Models::BaseModel.respond_to? :underscore).to be true
    end

    it 'should convert CamelCase to undersocre separated words' do
      expect(AeriesNetApi::Models::BaseModel.underscore 'SchoolInformationTerm').to be_eql 'school_information_term'
      expect(AeriesNetApi::Models::BaseModel.underscore 'School').to be_eql 'school'
      expect(AeriesNetApi::Models::BaseModel.underscore '_School').to be_eql '_school'
    end

  end

  context 'parse method' do

    it 'should parse json data and fill all attributes' do
      data = {"SchoolCode"=> 0, "Name"=>'test school'}.to_json
      model = AeriesNetApi::Models::TestModel.new(data)
      expect(model.school_code).to be_eql data['SchoolCode']
      expect(model.name).to be_eql data['Name']
    end

  end
end

module AeriesNetApi
  module Models
    class TestModel < AeriesNetApi::Models::BaseModel
      @@aeries_attributes_list= %w{SchoolCode Name}
      @@setters_list = self.process_aeries_attributes(@@aeries_attributes_list)

      def initialize(aeries_data=nil)
        parse(aeries_data, @@aeries_attributes_list, @@setters_list) if aeries_data.present?
      end

      # Overrides 'inspect' method to show only created attributes
      def inspect
        model_inspect(@@setters_list)
      end

      def attributes
        model_attributes(@@setters_list)
      end
    end
  end
end