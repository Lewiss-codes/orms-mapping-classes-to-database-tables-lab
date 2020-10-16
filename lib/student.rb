class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id=nil)
    @name =name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL 
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY, 
        name TEXT, 
        grade INTEGER
        )
        SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    DB[:conn].execute("DROP TABLE students")
  end

  def save 
    save_sql = <<-SQL
      INSERT INTO
        students (name, grade) 
      VALUES 
        (?, ?)
    SQL

    id_sql = <<-SQL 
    SELECT 
      last_insert_rowid()
    FROM 
      students
    SQL

    DB[:conn].execute(save_sql, self.name, self.grade)
    @id = DB[:conn].execute(id_sql)[0][0]
  end

  def self.create(name:, grade:)
    student = Student.new(name, grade)
    student.save
    student    
  end

end
