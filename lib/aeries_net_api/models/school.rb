module AeriesNetApi
  module Models
    class School < AeriesNetApi::Models::BaseModel

      @@aeries_attributes_list= %w{Name InactiveStatusCode Address AddressCity AddressState AddressZipCode AddressZipExt DoNotReport StateCountyID StateDistrictID
           StateSchoolID LowGradeLevel HighGradeLevel Terms}

      @@attributes_list = @@aeries_attributes_list.map { |attribute| "#{self.underscore(attribute)}=".to_sym }

      @@attributes_list.each do |attribute|
        # removes = from attribute name
        attr_accessor attribute[0..attribute.length-2]
      end

      puts "executing ****"

      def initialize(aeries_data=nil)
        parse(aeries_data, @@aeries_attributes_list, @@attributes_list) if aeries_data.present?
      end
    end
  end
end