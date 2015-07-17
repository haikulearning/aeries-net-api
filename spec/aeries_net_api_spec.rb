require 'spec_helper'

describe AeriesNetApi do
  it 'has a version number' do
    expect(AeriesNetApi::VERSION).not_to be nil
  end

  describe Object.blank? do
    it 'should respond to blank? method' do
      expect(Object.new.respond_to?(:blank?)).to be true
    end

    it 'should return true for an empty string' do
      expect('   '.blank?).to be true
    end

    it 'should return true for an empty string' do
      expect(''.blank?).to be true
    end

    it 'should return false for a valid string' do
      expect('abc'.blank?).to be false
    end

    it 'should return true for a nil object' do
      expect(nil.blank?).to be true
    end

    it 'should return true for an empty array' do
      expect([].blank?).to be true
    end

    it 'should return false for a non empty array' do
      expect([1, 2, 3].blank?).to be false
    end

    it 'should return true for an empty hash' do
      expect({}.blank?).to be true
    end

    it 'should return false for a non empty hash' do
      expect({ :a => 1, :b => 2 }.blank?).to be false
    end

    it 'should return true for a boolean false' do
      expect(false.blank?).to be true
    end

    it 'should return false for a boolean true' do
      expect(true.blank?).to be false
    end
  end
end
