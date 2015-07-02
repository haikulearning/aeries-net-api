# Adds useful methods to Object class
module AeriesNetApi
  module Support

    # An object is blank if it’s false, empty, or a whitespace string. For example, ”, ‘ ’, nil, [], and {} are all blank.
    def blank?
      return true if nil?
      return self.gsub(/\s/, '').length==0 if self.kind_of? String
      return self.empty? if self.respond_to? :empty?
      return true if self.kind_of? FalseClass
      false
    end

    # An object is present if it’s not blank.
    def present?
      !blank?
    end
  end
end