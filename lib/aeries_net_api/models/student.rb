module AeriesNetApi
  module Models
    # Class to represent Student information extracted from Aeries site.
    class Student < AeriesNetApi::Models::BaseModel
      # List of attributes to be extracted from Aeries site.
      @@aeries_attributes_list = %w(PermanentID SchoolCode StudentNumber StateStudentID LastName FirstName MiddleName
                                    LastNameAlias FirstNameAlias MiddleNameAlias Sex Grade Birthdate ParentGuardianName
                                    HomePhone StudentMobilePhone MailingAddress MailingAddressCity MailingAddressState
                                    MailingAddressZipCode MailingAddressZipExt ResidenceAddress ResidenceAddressCity
                                    ResidenceAddressState ResidenceAddressZipCode ResidenceAddressZipExt AddressVerified
                                    EthnicityCode RaceCode1 RaceCode2 RaceCode3 RaceCode4 RaceCode5 UserCode1 UserCode2
                                    UserCode3 UserCode4 UserCode5 UserCode6 UserCode7 UserCode8 UserCode9 UserCode10
                                    UserCode11 UserCode12 UserCode13 SchoolEnterDate SchoolLeaveDate DistrictEnterDate
                                    TeacherNumber Track AttendanceProgramCodePrimary AttendanceProgramCodeAdditional1
                                    AttendanceProgramCodeAdditional2 LockerNumber LowSchedulingPeriod
                                    HighSchedulingPeriod InactiveStatusCode FamilyKey LanguageFluencyCode
                                    HomeLanguageCode CorrespondanceLanguageCode ParentEdLevelCode ParentEmailAddress
                                    StudentEmailAddress NetworkLoginID AtRiskPoints)

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

      # Overrides 'parse' method to parse dates
      def parse(aeries_data, aeries_attributes_list, setters_list)
        super
        self.birthdate = DateTime.parse(birthdate) unless birthdate.nil?
        self.school_enter_date = DateTime.parse(school_enter_date) unless school_enter_date.nil?
        self.school_leave_date = DateTime.parse(school_leave_date) unless school_leave_date.nil?
        self.district_enter_date = DateTime.parse(district_enter_date) unless district_enter_date.nil?
      end
    end
  end
end
