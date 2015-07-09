module AeriesNetApi
  module Models
    # Base class for al Models.
    class BaseModel
      # Load json elements into dynamically created attributes
      def parse(aeries_data, aeries_attributes_list, setters_list)
        return if aeries_data.blank?
        setters_list.each_with_index do |method, i|
          send(method, aeries_data[aeries_attributes_list[i]])
        end
      end

      # Dynamically creates attributes for class
      # Parameters
      # aeries_attributes - List of Aeries attributes to be stored.
      # Returns list of methods to be invoked when parseing object
      def self.process_aeries_attributes(aeries_attributes)
        return_list = aeries_attributes.map { |attribute| "#{underscore(attribute)}=".to_sym }
        return_list.each do |attribute|
          # removes '=' from attribute name
          attr_accessor attribute[0..-2]
        end
        return_list
      end

      protected

      # Creates hash with attributes and values
      # Parameters
      # setters_list  - List of methods used to create/update attributes
      # Return
      # Hash of attributes with their values
      def model_attributes(setters_list)
        attributes = {}
        setters_list.each do |setter|
          attribute = setter[0..-2] # get rid of =
          value = send(attribute)
          attributes[attribute.to_sym] = value
        end
        attributes
      end

      # Overrides 'inspect' method to show only dynamically created attributes corresponding to Aeries attributes
      # Parameters
      # setters_list  - list of methods used to create/update attributes
      # Return
      # String with similar content to Object#inspect
      def model_inspect(setters_list)
        attributes_list = model_attributes(setters_list)
        "#<#{self.class}:0x#{format('%014x', object_id << 1)} #{attributes_list.inspect}>"
      end

      # Convert Camel case words into underscore separated words.
      # Example: underscore 'SchoolName'  =>  school_name
      # Parameters
      # camel_case_word - word to be converted
      # Return
      # Word converted to snake case
      def self.underscore(camel_case_word)
        camel_case_word.gsub(/::/, '/')
          .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
          .gsub(/([a-z\d])([A-Z])/, '\1_\2')
          .tr('-', '_').downcase
      end
    end
  end
end
