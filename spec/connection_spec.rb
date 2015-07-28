require 'spec_helper'

describe AeriesNetApi::Connection do
  describe 'constructor' do
    context 'right parameters' do
      it 'should set connection parameters' do
        connection = AeriesNetApi::Connection.new(:debug => true, :url => 'my_site', :certificate => 'abc')
        expect(connection.aeries_certificate).to eq 'abc'
        expect(connection.aeries_url).to eq 'my_site'
        expect(connection.debug?).to be true
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
        expect { AeriesNetApi::Connection.new }.to raise_error(RuntimeError)
      end

      it 'should read url parameter from configuration file if not received' do
        connection = AeriesNetApi::Connection.new(:certificate => 'abc')
        expect(connection.aeries_certificate).to eql 'abc'
        expect(connection.aeries_url).not_to be_empty
      end

      it 'should read certificate parameter from configuration file if not received' do
        connection = AeriesNetApi::Connection.new(:url => 'my_site')
        expect(connection.aeries_certificate).not_to be_empty
        expect(connection.aeries_url).to eql 'my_site'
      end
    end

    context 'debug settings' do
      context 'missing DEBUG env variable' do
        it 'should set debug if debug parameter present' do
          connection = AeriesNetApi::Connection.new(:debug => true)
          expect(connection.debug?).to be true
        end

        it 'debug? should be false if debug parameter missing' do
          connection = AeriesNetApi::Connection.new
          expect(connection.debug?).to be false
        end
      end

      context 'DEBUG env variable set' do
        it 'should not set debug if DEBUG=0' do
          previous = ENV['DEBUG']
          ENV['DEBUG'] = '0'
          connection = AeriesNetApi::Connection.new(:debug => true)
          expect(connection.debug?).to be false
          ENV['DEBUG'] = previous
        end

        it 'should set debug if DEBUG=1' do
          previous = ENV['DEBUG']
          ENV['DEBUG'] = '1'
          connection = AeriesNetApi::Connection.new(:debug => false)
          expect(connection.debug?).to be true
          connection = AeriesNetApi::Connection.new
          expect(connection.debug?).to be true
          ENV['DEBUG'] = previous
        end
      end
    end
  end

  describe 'methods' do
    let(:connection) { AeriesNetApi::Connection.new(:certificate => RSpec.configuration.aeries_certificate, :url => RSpec.configuration.aeries_url) }
    let(:student_id) { 99400003 }
    let(:school_code) { 994 }
    let(:section_number) { 43 }
    let(:gradebook_number) { 5350229 }
    let(:gradebook_term_code) { 'Y' }
    let(:assignment_number) { 1 }

    context 'schools' do
      it 'should include a schools method' do
        expect(connection.respond_to?(:schools)).to be true
      end

      it 'should return school information for a given id' do
        school = connection.schools(school_code)
        expect(school).to be_an_instance_of(AeriesNetApi::Models::School)
      end

      it 'school should include an array of terms' do
        school = connection.schools(school_code)
        expect(school.terms).to be_an_instance_of(Array)
        expect(school.terms.first).to be_an_instance_of(AeriesNetApi::Models::Term)
      end

      it 'should return a list of schools when an id was not given' do
        schools = connection.schools
        expect(schools).to be_an_instance_of(Array)
        expect(schools.first).to be_an_instance_of(AeriesNetApi::Models::School)
      end
    end

    context 'terms' do
      it 'should include a terms method' do
        expect(connection.respond_to?(:terms)).to be true
      end

      it 'should return a list of terms for a given school' do
        terms = connection.terms(1)
        expect(terms).to be_instance_of Array
        expect(terms.first).to be_an_instance_of(AeriesNetApi::Models::Term)
      end
    end

    context 'students' do
      it 'should include a students method' do
        expect(connection.respond_to?(:students)).to be true
      end

      it 'should return an empty array for an invalid school' do
        students = connection.students(-1)
        expect(students).to be_instance_of Array
        expect(students).to be_empty
      end

      it 'should return a list of students for a given school' do
        students = connection.students(school_code)
        expect(students).to be_instance_of Array
        expect(students.first).to be_an_instance_of(AeriesNetApi::Models::Student)
      end

      it 'should return a list of students for a given school and student id' do
        students = connection.students(school_code, student_id)
        expect(students).to be_instance_of Array
        expect(students.first).to be_an_instance_of(AeriesNetApi::Models::Student)
      end
    end

    context 'contacts' do
      it 'should include a contacts method' do
        expect(connection.respond_to?(:contacts)).to be true
      end

      it 'should return a list of contacts for a given school' do
        contacts = connection.contacts(school_code)
        expect(contacts).to be_instance_of Array
        expect(contacts.first).to be_an_instance_of(AeriesNetApi::Models::Contact)
      end

      it 'should return a list of contacts for a given school and student id' do
        contacts = connection.contacts(school_code, student_id)
        expect(contacts).to be_instance_of Array
        expect(contacts.first).to be_an_instance_of(AeriesNetApi::Models::Contact)
        expect(contacts.first.permanent_id).to eql student_id
        expect(contacts.first.school_code).to eql school_code
      end
    end

    context 'classes' do
      it 'should include a classes method' do
        expect(connection.respond_to?(:classes)).to be true
      end

      it 'should return a list of classes for a given school' do
        classes = connection.classes(school_code)
        expect(classes).to be_instance_of Array
        expect(classes.first).to be_an_instance_of(AeriesNetApi::Models::StudentClass)
      end

      it 'should return a list of classes for a given school and student id' do
        classes = connection.classes(school_code, student_id)
        expect(classes).to be_instance_of Array
        expect(classes.first).to be_an_instance_of(AeriesNetApi::Models::StudentClass)
        expect(classes.first.permanent_id).to eql student_id
        expect(classes.first.school_code).to eql school_code
      end
    end

    context 'courses' do
      it 'should include a courses method' do
        expect(connection.respond_to?(:courses)).to be true
      end

      it 'should return course information for a given id' do
        course = connection.courses('0001')
        expect(course).to be_an_instance_of(AeriesNetApi::Models::Course)
        expect(course.id).to eql '0001'
      end

      it 'should return a list of courses when an id was not given' do
        courses = connection.courses
        expect(courses).to be_an_instance_of(Array)
        expect(courses.first).to be_an_instance_of(AeriesNetApi::Models::Course)
      end

      it 'should raise an error for a non existent course' do
        expect { connection.courses('1') }.to raise_error(RuntimeError, /404/)
      end
    end

    context 'staff' do
      let(:staff_id) { 990001 }

      it 'should include a staff method' do
        expect(connection.respond_to?(:staff)).to be true
      end

      it 'should return staff member information for a given id' do
        staff_member = connection.staff(staff_id)
        expect(staff_member).to be_an_instance_of(AeriesNetApi::Models::Staff)
        expect(staff_member.id).to eql staff_id
      end

      it 'should return a list of staff members when an id was not given' do
        staff = connection.staff
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
        teacher = connection.teachers(school_code, 601)
        expect(teacher).to be_an_instance_of(AeriesNetApi::Models::Teacher)
      end

      it 'should return a list of teachers when an id was not given' do
        teachers = connection.teachers(school_code)
        expect(teachers).to be_an_instance_of(Array)
        expect(teachers.first).to be_an_instance_of(AeriesNetApi::Models::Teacher)
      end

      it 'should raise an error for a non existent teacher' do
        expect { connection.teachers(school_code, 1) }.to raise_error(StandardError, %r{#{school_code}}) # rubocop:disable Style/RegexpLiteral
      end
    end

    context 'sections' do
      it 'should include a sections method' do
        expect(connection.respond_to?(:sections)).to be true
      end

      it 'should return section information for a given section number' do
        section = connection.sections(school_code, section_number)
        expect(section).to be_an_instance_of(AeriesNetApi::Models::Section)
        expect(section.section_number).to eql(section_number)
      end

      it 'should return a list of sections when an id was not given' do
        sections = connection.sections(school_code)
        expect(sections).to be_an_instance_of(Array)
        expect(sections.first).to be_an_instance_of(AeriesNetApi::Models::Section)
      end

      it 'should return an empty list when an invalid school code was given' do
        sections = connection.sections(0)
        expect(sections).to be_an_instance_of(Array)
        expect(sections).to be_empty
      end

      it 'should raise an error for a non existent section' do
        expect { connection.sections(school_code, 145) }.to raise_error(StandardError, /145/)
      end
    end

    context 'class roster' do
      it 'should include a class_roster method' do
        expect(connection.respond_to?(:class_roster)).to be true
      end

      it 'should return class roster for a given school/section number' do
        list = connection.class_roster(school_code, section_number)
        expect(list).to be_an_instance_of Array
        expect(list.first).to be_an_instance_of(AeriesNetApi::Models::StudentClass)
      end

      it 'should return an empty list when an invalid school code was given' do
        list = connection.class_roster(0, 998)
        expect(list).to be_an_instance_of(Array)
        expect(list).to be_empty
      end
    end

    context 'gradebooks' do
      let(:gradebooks) { connection.gradebooks(school_code, section_number) }

      it 'should include a gradebooks method' do
        expect(connection.respond_to?(:gradebooks)).to be true
      end

      it 'should return a list of gradebooks ' do
        expect(gradebooks).to be_an_instance_of(Array)
        expect(gradebooks.first).to be_an_instance_of(AeriesNetApi::Models::Gradebook)
      end

      it 'school should include a GradebookSettings object' do
        expect(gradebooks.first.settings).to be_an_instance_of(AeriesNetApi::Models::GradebookSettings)
      end

      it 'school should include an array of AssignmentCategory objects' do
        expect(gradebooks.first.assignment_categories).to be_an_instance_of(Array)
        expect(gradebooks.first.assignment_categories.first).to be_an_instance_of(AeriesNetApi::Models::AssignmentCategory)
      end

      it 'school should include an array of GradebookSection objects' do
        expect(gradebooks.first.sections).to be_an_instance_of(Array)
        expect(gradebooks.first.sections.first).to be_an_instance_of(AeriesNetApi::Models::GradebookSection)
      end

      it 'school should include an array of GradebookTerm objects' do
        expect(gradebooks.first.terms).to be_an_instance_of(Array)
        expect(gradebooks.first.terms.first).to be_an_instance_of(AeriesNetApi::Models::GradebookTerm)
      end
    end

    context 'single gradebook' do
      it 'should include a gradebook method' do
        expect(connection.respond_to?(:gradebook)).to be true
      end

      it 'should return a single Gradebook object for a given gradebook number' do
        gradebooks      = connection.gradebooks(school_code, section_number)
        first_gradebook = gradebooks.first
        gradebook       = connection.gradebook(first_gradebook.gradebook_number)
        expect(first_gradebook.gradebook_number).to eql(gradebook.gradebook_number)
        expect first_gradebook.eql? gradebook
      end
    end

    context 'assignments' do
      let(:list) { connection.assignments(gradebook_number) }

      it 'should include an assignments method' do
        expect(connection.respond_to?(:assignments)).to be true
      end

      it 'should return an array of Assignment objects for a given gradebook number' do
        expect(list).to be_an_instance_of Array
        expect(list.first).to be_an_instance_of(AeriesNetApi::Models::Assignment)
      end

      it 'should include an AssignmentCategory object' do
        expect(list.first.assignment_category).to be_an_instance_of(AeriesNetApi::Models::AssignmentCategory)
      end

      it 'should include an AssignmentStandard object array ' do
        expect(list.first.standards).to be_an_instance_of(Array)
        expect(list.first.standards.first).to be_an_instance_of(AeriesNetApi::Models::AssignmentStandard) unless list.first.standards.empty?
      end

      it 'should return an empty list when an invalid gradebook code was given' do
        list = connection.assignments(998)
        expect(list).to be_an_instance_of(Array)
        expect(list).to be_empty
      end

      it 'should return a single AssignmentObject when assignment number is passed' do
        assignment_number = list.first.assignment_number
        assignment        = connection.assignments(gradebook_number, assignment_number)
        expect(assignment).to be_an_instance_of(AeriesNetApi::Models::Assignment)
        expect(assignment.assignment_number).to eql assignment_number
      end
    end

    context 'final marks' do
      let(:list) { connection.final_marks(gradebook_number) }

      it 'should include an final_marks method' do
        expect(connection.respond_to?(:final_marks)).to be true
      end

      it 'should return an array of final marks for a given gradebook number' do
        expect(list).to be_an_instance_of Array
        expect(list.first).to be_an_instance_of(AeriesNetApi::Models::FinalMark)
      end

      it 'should return an empty list when an invalid gradebook code was given' do
        list = connection.final_marks(998)
        expect(list).to be_an_instance_of(Array)
        expect(list).to be_empty
      end
    end

    context 'gpas' do
      it 'should include a gpas method' do
        expect(connection.respond_to?(:gpas)).to be true
      end

      it 'should return an empty array for an invalid school' do
        gpas = connection.gpas(-1)
        expect(gpas).to be_instance_of Array
        expect(gpas).to be_empty
      end

      it 'should return a list of gpas for a given school' do
        gpas = connection.gpas(school_code)
        expect(gpas).to be_instance_of Array
        expect(gpas.first).to be_an_instance_of(AeriesNetApi::Models::GPA)
      end

      it 'should return a list of gpas for a given school and student id' do
        gpas = connection.gpas(school_code, student_id)
        expect(gpas).to be_instance_of Array
        expect(gpas.first).to be_an_instance_of(AeriesNetApi::Models::GPA)
      end
    end

    context 'student_programs' do
      it 'should include a student_programs method' do
        expect(connection.respond_to?(:student_programs)).to be true
      end

      it 'should return an empty array for an invalid school' do
        programs = connection.student_programs(-1)
        expect(programs).to be_instance_of Array
        expect(programs).to be_empty
      end

      it 'should return a list of student programs for a given school' do
        programs = connection.student_programs(school_code)
        expect(programs).to be_instance_of Array
        expect(programs.first).to be_an_instance_of(AeriesNetApi::Models::StudentProgram)
      end

      it 'should return a list of student programs for a given school and student id' do
        programs_list = connection.student_programs(school_code) # get all programs to find a valid student id
        program       = connection.student_programs(school_code, programs_list.first.student_id)
        expect(program).to be_instance_of Array
        expect(program.first).to be_an_instance_of(AeriesNetApi::Models::StudentProgram)
        expect(program.first.student_id).to eql programs_list.first.student_id
      end
    end

    context 'codes' do
      let(:table_code) { 'STU' } # Students table
      let(:field_code) { 'RC1' } # field code
      let(:list) { connection.codes(table_code, field_code) }

      it 'should include a codes method' do
        expect(connection.respond_to?(:codes)).to be true
      end

      it 'should return an array of code for a given table/field' do
        expect(list).to be_an_instance_of Array
        expect(list.first).to be_an_instance_of(AeriesNetApi::Models::Code)
      end

      it 'should return an array of code with same table/field given' do
        expect(list).to be_an_instance_of Array
        expect(list.first.table).to eql(table_code)
        expect(list.first.field).to eql(field_code)
      end

      it 'should return an empty list when an invalid table or code was given' do
        list = connection.codes('xxx', 'yyy')
        expect(list).to be_an_instance_of(Array)
        expect(list).to be_empty
      end
    end

    context 'gradebooks_students' do
      it 'should include a gradebooks_students method' do
        expect(connection.respond_to?(:gradebooks_students)).to be true
      end

      it 'should return an array of student objects for a given gradebook_number/term_code' do
        list = connection.gradebooks_students(gradebook_number, gradebook_term_code)
        expect(list).to be_an_instance_of Array
        expect(list.first).to be_an_instance_of(AeriesNetApi::Models::GradebookStudent)
      end

      it 'should return a student object for a given gradebook_number/term_code/student' do
        list    = connection.gradebooks_students(gradebook_number, gradebook_term_code)
        student = connection.gradebooks_students(gradebook_number, gradebook_term_code, list.first.permanent_id)
        expect(student).to be_an_instance_of AeriesNetApi::Models::GradebookStudent
        expect(list.first.permanent_id).to eql student.permanent_id
      end

      it 'should return an empty list when an invalid gradebook code was given' do
        list = connection.gradebooks_students(777, gradebook_term_code)
        expect(list).to be_an_instance_of(Array)
        expect(list).to be_empty
      end
    end

    context 'assignments_scores' do
      let(:list) { connection.assignments_scores(gradebook_number, assignment_number) }

      it 'should include an assignments_scores method' do
        expect(connection.respond_to?(:assignments_scores)).to be true
      end

      it 'should return an array of AssignmentScore for a given gradebook_ number/assignment_number' do
        expect(list).to be_an_instance_of Array
        expect(list.first).to be_an_instance_of(AeriesNetApi::Models::AssignmentScore)
      end

      it 'should include an AssignmentStandardScore object array ' do
        expect(list.first.standard_scores).to be_an_instance_of(Array)
        expect(list.first.standard_scores.first).to be_an_instance_of(AeriesNetApi::Models::AssignmentStandardScore) unless list.first.standard_scores.empty?
      end

      it 'should return an empty list when an invalid gradebook and/or assignment_number code was given' do
        scores_list = connection.assignments_scores(998, 7)
        expect(scores_list).to be_an_instance_of(Array)
        expect(scores_list).to be_empty
      end
    end

    context 'update_gradebook_scores' do
      it 'should contains an update_gradebook_scores method' do
        expect(connection.respond_to?(:update_gradebook_scores)).to be true
      end

      it 'should validate parameter received as an array of AssignmentScoreUpdate objects' do
        list = (1..3).map { AeriesNetApi::Update::AssignmentScoreUpdate.new }
        expect { connection.update_gradebook_scores(gradebook_number, assignment_number, list) }.to_not raise_error
        expect { connection.update_gradebook_scores(gradebook_number, assignment_number, nil) }.to raise_error(ArgumentError)
        expect do
          connection.update_gradebook_scores(gradebook_number, assignment_number, [1, 2, AeriesNetApi::Update::AssignmentScoreUpdate.new])
        end.to raise_error(ArgumentError)
      end

      it 'should update score using only AssignmentScoreUpdate object ' do
        # Get current data
        scores_list    = connection.assignments_scores(gradebook_number, assignment_number)
        score          = scores_list.first
        number_correct = Random.new.rand(1.00..5.00).round(4)
        item           = AeriesNetApi::Update::AssignmentScoreUpdate.new(:permanent_id   => score.permanent_id,
                                                                         :number_correct => number_correct,
                                                                         :date_completed => Date.today)
        updated_list   = connection.update_gradebook_scores(gradebook_number, assignment_number, [item])
        updated        = updated_list.first
        expect(updated.permanent_id).to eql(score.permanent_id)
        expect(updated.number_correct).to eql(number_correct)
      end

      it 'should update scores using aeries_standard_id if score has standard_scores' do
        # Get current data
        scores_list = connection.assignments_scores(gradebook_number, assignment_number)
        # Look for an score with standard scores
        score       = nil
        scores_list.each do |item|
          unless item.standard_scores.empty?
            score = item
            break
          end
        end
        unless score.nil?
          assignment = connection.assignments(gradebook_number, assignment_number)
          puts assignment.inspect
          number_correct  = Random.new.rand(1.00..5.00).round(4)
          standard_scores = [AeriesNetApi::Update::AssignmentStandardScoreUpdate.new(:aeries_standard_id => assignment.standards.first.standard_id,
                                                                                     :number_correct => number_correct)]
          item            = AeriesNetApi::Update::AssignmentScoreUpdate.new(:permanent_id    => score.permanent_id,
                                                                            :date_completed  => Date.today,
                                                                            :standard_scores => standard_scores)
          updated_list    = connection.update_gradebook_scores(gradebook_number, assignment_number, [item])
          updated         = updated_list.first
          expect(updated.permanent_id).to eql(score.permanent_id)
          expect(updated.number_correct).to eql(number_correct)
        end
      end
    end
  end
end
