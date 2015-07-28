# rubocop: disable Lint/NestedMethodDefinition
module AeriesNetApi
  # Adds useful methods to Object class
  module Support
    # Overrides parent#included.  Used to avoid re-define these methods when running under Rails
    def self.included(base)
      unless base.respond_to?(:blank?)
        base.class_eval do
          # An object is blank if it's false, empty, or a whitespace string. For example, " ", ' '', nil, [], and {} are all blank.
          def blank?
            return true if nil?
            return gsub(/\s/, '').length == 0 if is_a? String
            return empty? if respond_to? :empty?
            return true if self.is_a? FalseClass
            false
          end
        end
      end

      unless base.respond_to?(:present?)
        base.class_eval do
          # An object is present if it's not blank.
          def present?
            !blank?
          end
        end
      end
    end
  end
end
# rubocop: enable Lint/NestedMethodDefinition
