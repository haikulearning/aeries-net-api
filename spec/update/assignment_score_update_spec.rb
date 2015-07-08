require 'spec_helper'

describe AeriesNetApi::Update::AssignmentScoreUpdate do
  describe 'constructor'
  context 'right parameters' do
    it 'should set object properties' do
      update_object = AeriesNetApi::Update::AssignmentScoreUpdate.new(:permanent_id => 123, :number_correct=>5,
                                                                      :date_completed=>Date.today,:standard_scores=>[])
      expect(update_object.permanent_id).to eql 123
      expect(update_object.number_correct).to eql 5
      expect(update_object.date_completed).to eql Date.today
      expect(update_object.standard_scores).to be_an_instance_of Array
      expect(update_object.standard_scores).to be_empty


    end
  end

  context 'wrong parameters' do
    it 'should raise an error for invalid parameters' do
      # message should not contain a valid parameter like permanent_id
      expect { AeriesNetApi::Update::AssignmentScoreUpdate.new(:wrong => 'my_site', :another_wrong => 'abc',:permanent_id=>'123') }.to \
          raise_error(ArgumentError) {|error| expect(!(error.message=~/wrong/).nil? && (error.message =~ /permanent_id/).nil?).to be true  }
    end
  end

end