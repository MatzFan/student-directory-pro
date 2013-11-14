require 'pry'
require 'csv'

=begin
students = [
  {name: 'Bruce Steedman', cohort: :november},
  {name: 'James Brooke', cohort: :november},
  {name: 'Chis..', cohort: :november},
  {name: 'Hannah..', cohort: :november},
  {name: 'Lara Young', cohort: :november},
  {name: 'Jeremy Marer', cohort: :november},
  {name: 'Kennedy..', cohort: :november},
  {name: 'Simon Woolf', cohort: :november},
  {name: 'Tom..', cohort: :november},
  {name: 'Tom..', cohort: :november},
  {name: 'Giacomo..', cohort: :november},
  {name: 'Anath Abensour', cohort: :november},
  {name: 'Asta..', cohort: :november},
  {name: 'Kumi..', cohort: :november},
  {name: 'Nisar..', cohort: :november},
  {name: 'Georgi..', cohort: :november},
  {name: 'Peter Kristo', cohort: :november},
  {name: 'Jean-Baptiste..', cohort: :november}
  {name: 'Ken..', cohort: :november}
  {name: 'Erica..', cohort: :november}
]
=end
class StudentDirectory

  MONTHS = Date::MONTHNAMES
  HEADER = "The students of my cohort at Makers Academy"
  STUDENT_ATTRIBUTES = {cohort: MONTHS[11], name: 'Unknown', hobby: 'None', country: nil}

  attr_accessor :students

  def initialize
    @students = []
  end

  def interactive_menu
    loop do
      print_menu
      process(gets.chomp)
    end
  end

  def input_students
  	puts "Please enter the details for each student\nTo finish just hit return twice"
  	loop do
      puts @students.length
      if !(@students.length == 0) # assumes user wants to enter at least one student
        puts 'Another?'
        another = gets.strip
        break if another =~/[Nn]/
      end
      @students << input_student_attributes # appends a new student to the array
      puts "Now we have #{students.size} student" + (@students.size > 1 ? "s" : "")
    end
  end

  def print_students_list
  	@students.each_with_index do |s, index|
      # cycle through each attribute hash & print value for each
      msg = ""
      STUDENT_ATTRIBUTES.map { |k,v| msg += "#{s[k]} " }
  	  puts "#{index+1}. #{msg}".center(HEADER.length)
  	end
  end

  def print_students_by_cohort(cohort)
    relevant_students = @students.select {|s| s[:cohort] == cohort}
    relevant_students.each_with_index do |s, index|
      puts "#{s[:cohort]} Cohort"
      puts
      msg = ""
      STUDENT_ATTRIBUTES.map do |k,v|
        msg += "#{s[k]} " unless k == :cohort # excludes group attribute
      end
      puts "#{index+1}. #{msg}".center(HEADER.length)
    end
  end

  def save_students(file) # WHY WRITE DATA A LINE AT A TIME?
    File.open(file, "w") { |f| @students.each {|s| f.puts s.values.join(',')} }
  end

  private
  def print_header
    puts HEADER
    HEADER.size.times { print '-' }
    puts
  end

  private
  def print_footer
    print "Overall we have #{@students.size} great students.\n"
  end

  private
  def input_student_attributes
    student = {}
    STUDENT_ATTRIBUTES.each do |attribute, default| # elements are hashes
      puts "Enter #{attribute.capitalize}, just hit enter for default value: #{default}"
      input_value = gets.chomp
      if !input_value.empty?
        # first validate the input
        student[attribute] = check_input(attribute, input_value)
      else
        student[attribute] = default # if empty string use the default
      end
    end
    student
  end

  # Validates user input
  private
  def check_input(attribute, user_input)
    if attribute == :cohort
      loop do
        if MONTHS.include? user_input # check it is a valid month
          return user_input.to_sym
        end
        puts "Sorry, please enter a valid month"
        user_input = gets.chomp
      end
    end
    user_input
  end

  private
  def process(selection)
    case selection
    when "1"
      input_students
    when "2"
      show_students
    when "3"
      save_students("students.csv")
    when "9"
      exit
    else
      puts "Sorry, I don't recognise that command, try again"
    end
  end

  private
  def print_menu
    puts "1. Input the students"
    puts "2. Show the students"
    puts "3. Save students to csv"
    puts "9. Exit"
  end

  private
  def show_students
    print_header
    print_students_list
    print_footer
  end

end # of class

dir = StudentDirectory.new
dir.interactive_menu

