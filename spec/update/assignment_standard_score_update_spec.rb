require 'spec_helper'

describe AeriesNetApi::Update::AssignmentStandardScoreUpdate do
  describe 'constructor'
  context 'right parameters' do
    it 'should set object properties' do
      update_object = AeriesNetApi::Update::AssignmentStandardScoreUpdate.new(:aeries_standard_id    => 123,
                                                                              :academic_benchmark_id => 5, :number_correct => 4.25)
      expect(update_object.aeries_standard_id).to eql 123
      expect(update_object.academic_benchmark_id).to eql 5
      expect(update_object.number_correct).to eql 4.25
    end
  end

  context 'wrong parameters' do
    it 'should raise an error for invalid parameters' do
      # message should not contain a valid parameter like permanent_id
      expect { AeriesNetApi::Update::AssignmentStandardScoreUpdate.new(:wrong => 'my_site', :another_wrong => 'abc', :permanent_id => '123') }.to \
        raise_error(ArgumentError) { |error| expect(!(error.message =~ /wrong/).nil? && (error.message =~ /aeries_standard_id/).nil?).to be true }
    end
  end
end
