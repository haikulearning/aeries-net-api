module AeriesNetApi
  module Models
    class BaseModel

      def parse(aeries_data, aeries_attributes_list, attributes_list)
        return if aeries_data.blank?
        attributes_list.each_with_index do |method, i|
          send(method, aeries_data[aeries_attributes_list[i]])
        end
      end

      protected

      def self.underscore(camel_case_word)
        camel_case_word.gsub(/::/, '/').
            gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
            gsub(/([a-z\d])([A-Z])/, '\1_\2').
            tr("-", "_").downcase
      end
    end
  end
end