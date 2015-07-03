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
        expect{connection.courses('1')}.to raise_error(RuntimeError, /404/)
      end
    end

  end
end