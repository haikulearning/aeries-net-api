module AeriesNetApi
  module Models
    # Class to represent student Contact information extracted from Aeries site.
    class Contact < AeriesNetApi::Models::BaseModel
      # List of attributes to be extracted from Aeries site.
      @@aeries_attributes_list = %w(PermanentID SchoolCode SequenceNumber MailingName NamePrefix FirstName LastName
                                    MiddleName NameSuffix Address AddressCity AddressState AddressZipCode AddressZipExt
                                    RelationshipToStudentCode LivesWithStudentIndicator RedFlag HomePhone WorkPhone
                                    WorkPhoneExt CellPhone Pager EmailAddress AccessToPortal ContactOrder
                                    CorrespondanceLanguageCode EmployerName EmployerLocation MilitaryBranchCode
                                    MilitaryRankCode MilitarySupervisorName MilitarySupervisorPhone MilitaryStatusCode)

      # List of methods to be used to create object's attributes dynamically.
      @@setters_list = process_aeries_attributes(@@aeries_attributes_list)

      # Creates a new object from data received from Aeries site.  It creates a new empty object if no data is received.
      def initialize(aeries_data = nil)
        parse(aeries_data, @@aeries_attributes_list, @@setters_list) if aeries_data.present?
      end

      # Overrides 'inspect' method to show only created attributes
      def inspect
        model_inspect(@@setters_list)
      end

      # Returns a hash of attributes extracted from Aeries site
      def attributes
        model_attributes(@@setters_list)
      end
    end
  end
end
