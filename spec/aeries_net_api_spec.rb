require 'spec_helper'

describe AeriesNetApi do


  it 'has a version number' do
    expect(AeriesNetApi::VERSION).not_to be nil
  end

  describe Object::blank? do
    it 'should respond to blank? method' do
      expect(Object.new.respond_to?(:blank?)).to be true
    end

    it 'should return true for an empty string' do
      expect('   '.blank?).to be true
    end

    it 'should return true for a nil object' do
      expect(nil.blank?).to be true
    end

    it 'should return true for an empty array' do
      expect([].blank?).to be true
    end

    it 'should return true for an empty hash' do
      expect({}.blank?).to be true
    end

  end
end
