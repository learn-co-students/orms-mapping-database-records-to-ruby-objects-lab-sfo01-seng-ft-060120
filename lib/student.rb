require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = Student.new 
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    sql = <<-SQL
    SELECT *
    FROM students;
    SQL
    all = DB[:conn].execute(sql)
    all.map { |student| self.new_from_db(student) }
    # remember each row should be a new instance of the Student class
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    # self.all.find { |student| student.name == name }
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE name == ?;
    SQL
    student = DB[:conn].execute(sql, name)
    student.map { |student| self.new_from_db(student)}.first
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.all_students_in_grade_9
    # self.all.find_all { |student| student.grade == "9"}
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade == "9";
    SQL
    student = DB[:conn].execute(sql)
    student.map {|student| self.new_from_db(student)}
  end

  def self.students_below_12th_grade
    sql = <<-SQL
    SELECT * 
    FROM students
    WHERE grade != "12";
    SQL
    students = DB[:conn].execute(sql)
    students.map { |student| self.new_from_db(student)}
  end

  def self.first_X_students_in_grade_10(num)
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade == "10"
    LIMIT ?;
    SQL
    students = DB[:conn].execute(sql, num)
    students.map { |student| self.new_from_db(student)}
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade == "10"
    SQL
    students = DB[:conn].execute(sql)
    students.map { |student| self.new_from_db(student)}.first
  end

  def self.all_students_in_grade_X(num)
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade == ?
    SQL
    students = DB[:conn].execute(sql, num)
    students.map { |student| self.new_from_db(student)}
  end
end
