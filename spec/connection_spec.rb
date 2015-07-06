require 'spec_helper'
# ToDo: add specs to test handling of response errors.
# ToDo: add specs to test connectivity

describe AeriesNetApi::Connection do

  describe 'constructor' do
    context 'right parameters' do
      it 'should set connection parameters' do
        connection = AeriesNetApi::Connection.new(:url => 'my_site', :certificate => 'abc')
        expect(connection.aeries_certificate).to eq 'abc'
        expect(connection.aeries_url).to eq 'my_site'
      end
    end

    context 'wrong parameters' do
      it 'should raise an error for invalid parameters' do
        expect { AeriesNetApi::Connection.new(:wrong_url => 'my_site', :certificate => 'abc') }.to raise_error(ArgumentError)
      end
    end

    context 'missing parameters' do
      it 'should raise an error if config file can\'t be found' do
        allow(Dir).to receive(:pwd) { 'non_existent_directory' }
        expect { AeriesNetApi::Connection.new() }.to raise_error(RuntimeError)
      end

      it 'should read url parameter from configuration file if not received' do
        connection = AeriesNetApi::Connection.new(:certificate => 'abc')
        expect(connection.aeries_certificate).to be_eql 'abc'
        expect(connection.aeries_url).not_to be_empty
      end

      it 'should read certificate parameter from configuration file if not received' do
        connection = AeriesNetApi::Connection.new(:url => 'my_site')
        expect(connection.aeries_certificate).not_to be_empty
        expect(connection.aeries_url).to be_eql 'my_site'
      end
    end
  end

  describe 'methods' do

    let(:connection) { AeriesNetApi::Connection.new(:certificate => RSpec.configuration.aeries_certificate, :url => RSpec.configuration.aeries_url) }
    let(:student_id) { 99400003 }
    let(:school_code) { 994 }

    context 'schools' do
      it 'should include a schools method' do
        expect(connection.respond_to?(:schools)).to be true
      end

      it 'should return school information for a given id' do
        school=connection.schools(school_code)
        expect(school).to be_an_instance_of(AeriesNetApi::Models::School)
      end

      it 'school should include an array of terms' do
        school=connection.schools(school_code)
        expect(school.terms).to be_an_instance_of(Array)
        expect(school.terms.first).to be_an_instance_of(AeriesNetApi::Models::Term)
      end

      it 'should return a list of schools when an id was not given' do
        schools=connection.schools()
        expect(schools).to be_an_instance_of(Array)
        expect(schools.first).to be_an_instance_of(AeriesNetApi::Models::School)
      end
    end

    context 'terms' do
      it 'should include a terms method' do
        expect(connection.respond_to?(:terms)).to be true
      end

      it 'should return a list of terms for a given school' do
        terms=connection.terms(1)
        expect(terms).to be_instance_of Array
        expect(terms.first).to be_an_instance_of(AeriesNetApi::Models::Term)
      end
    end

    context 'students' do
      it 'should include a terms method' do
        expect(connection.respond_to?(:students)).to be true
      end

      it 'should return an empty array for an invalid school' do
        students=connection.students(-1)
        expect(students).to be_instance_of Array
        expect(students).to be_empty
      end

      it 'should return a list of students for a given school' do
        students=connection.students(school_code)
        expect(students).to be_instance_of Array
        expect(students.first).to be_an_instance_of(AeriesNetApi::Models::Student)
      end

      it 'should return a list of students for a given school and student id' do
        students=connection.students(school_code, student_id)
        expect(students).to be_instance_of Array
        expect(students.first).to be_an_instance_of(AeriesNetApi::Models::Student)
      end
    end
    context 'contacts' do
      it 'should include a contacts method' do
        expect(connection.respond_to?(:contacts)).to be true
      end

      it 'should return a list of contacts for a given school' do
        contacts=connection.contacts(school_code)
        expect(contacts).to be_instance_of Array
        expect(contacts.first).to be_an_instance_of(AeriesNetApi::Models::Contact)
      end

      it 'should return a list of contacts for a given school and student id' do
        contacts=connection.contacts(school_code, student_id)
        expect(contacts).to be_instance_of Array
        expect(contacts.first).to be_an_instance_of(AeriesNetApi::Models::Contact)
        expect(contacts.first.permanent_id).to be_eql student_id
        expect(contacts.first.school_code).to be_eql school_code
      end
    end

    context 'classes' do
      it 'should include a classes method' do
        expect(connection.respond_to?(:classes)).to be true
      end

      it 'should return a list of classes for a given school' do
        classes=connection.classes(school_code)
        expect(classes).to be_instance_of Array
        expect(classes.first).to be_an_instance_of(AeriesNetApi::Models::StudentClass)
      end

      it 'should return a list of classes for a given school and student id' do
        classes=connection.classes(school_code, student_id)
        expect(classes).to be_instance_of Array
        expect(classes.first).to be_an_instance_of(AeriesNetApi::Models::StudentClass)
        expect(classes.first.permanent_id).to be_eql student_id
        expect(classes.first.school_code).to be_eql school_code
      end
    end


    context 'courses' do
      it 'should include a courses method' do
        expect(connection.respond_to?(:courses)).to be true
      end

      it 'should return course information for a given id' do
        course=connection.courses('0001')
        expect(course).to be_an_instance_of(AeriesNetApi::Models::Course)
        expect(course.id).to be_eql '0001'
      end

      it 'should return a list of courses when an id was not given' do
        courses=connection.courses()
        expect(courses).to be_an_instance_of(Array)
        expect(courses.first).to be_an_instance_of(AeriesNetApi::Models::Course)
      end

      it 'should raise an error for a non existent course' do
        expect { connection.courses('1') }.to raise_error(RuntimeError, /404/)
      end
    end

    context 'staff' do
      let(:staff_id) {990001}

      it 'should include a staff method' do
        expect(connection.respond_to?(:staff)).to be true
      end

      it 'should return staff member information for a given id' do
        staff_member=connection.staff(staff_id)
        expect(staff_member).to be_an_instance_of(AeriesNetApi::Models::Staff)
        expect(staff_member.id).to be_eql staff_id
      end

      it 'should return a list of staff members when an id was not given' do
        staff=connection.staff()
        expect(staff).to be_an_instance_of(Array)
        expect(staff.first).to be_an_instance_of(AeriesNetApi::Models::Staff)
      end

      it 'should raise an error for a non existent course' do
        expect { connection.staff('13') }.to raise_error(ArgumentError, /13/)
      end
    end

    context 'teachers' do
      it 'should include a teachers method' do
        expect(connection.respond_to?(:teachers)).to be true
      end

      it 'should return teacher information for a given teacher number' do
        teacher=connection.teachers(school_code,601)
        expect(teacher).to be_an_instance_of(AeriesNetApi::Models::Teacher)
      end

      it 'should return a list of teachers when an id was not given' do
        teachers=connection.teachers(school_code)
        expect(teachers).to be_an_instance_of(Array)
        expect(teachers.first).to be_an_instance_of(AeriesNetApi::Models::Teacher)
      end

      it 'should raise an error for a non existent teacher' do
        expect { connection.teachers(school_code,1) }.to raise_error(StandardError, %r[#{school_code}])
      end
    end

    context 'sections' do
      it 'should include a sections method' do
        expect(connection.respond_to?(:sections)).to be true
      end

      it 'should return section information for a given section number' do
        section=connection.sections(school_code,43)
        expect(section).to be_an_instance_of(AeriesNetApi::Models::Section)
      end

      it 'should return a list of sections when an id was not given' do
        sections=connection.sections(school_code)
        expect(sections).to be_an_instance_of(Array)
        expect(sections.first).to be_an_instance_of(AeriesNetApi::Models::Section)
      end

      it 'should return an empty list when an invalid school code was given' do
        sections=connection.sections(0)
        expect(sections).to be_an_instance_of(Array)
        expect(sections).to be_empty
      end

      it 'should raise an error for a non existent section' do
        expect { connection.sections(school_code,145) }.to raise_error(StandardError, /145/)
      end
    end

    context 'class roster' do
      it 'should include a class_roster method' do
        expect(connection.respond_to?(:class_roster)).to be true
      end

      it 'should return class roster for a given school/section number' do
        list=connection.class_roster(school_code,43)
        expect(list).to be_an_instance_of Array
        expect(list.first).to be_an_instance_of(AeriesNetApi::Models::StudentClass)
      end

      it 'should return an empty list when an invalid school code was given' do
        list=connection.class_roster(0,998)
        expect(list).to be_an_instance_of(Array)
        expect(list).to be_empty
      end
    end
  end
end