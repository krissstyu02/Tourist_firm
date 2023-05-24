require_relative 'client/models/client'
require_relative 'client/models/client_short'
require_relative 'client/data/containers/dataTable'
require 'mysql2'
require_relative 'client/data/client_db_adapter'
require_relative 'interface'



# student1 = Student.new('Гавриш', 'Геннадий', 'Алексеевич')
# student2 = Student.new('Петровв', 'Иван', 'Борисович', { id: 40, telegram: '@ivan45' })
# student3=StudentShort.new(student2)
# puts(student3.contact)
#
# student_list = [student1, student2]
# puts read_from_txt('/home/kristina/RubymineProjects/RubyProjects/Student_project/student_list.txt')
# write_to_txt('/home/kristina/RubymineProjects/RubyProjects/Student_project/student_list2.txt', student_list)

# test = [ [1,'One'], [2,'Two']]
# test_table = DataTable.new(test)
# puts test_table
# puts test_table.get_element(0,1)


# Создаем соединение с базой данных
# client = Mysql2::Client.new(
#   :host => 'localhost',
#   :username => 'root',
#   :password => 'Kris110902Star',
#   :database => 'student_db'
# )
#
# # Выполняем SELECT-запрос
# results = client.query('SELECT * FROM students')
#
# # Выводим результаты на экран
# results.each do |row|
#   puts row.inspect
# end


# Создаем экземпляр класса StudentListDB
# student_list = StudentList_db_Adapter.new
#
# # Тест метода student_by_id
# student = student_list.student_by_id(1)
# puts student.inspect

# # Тест метода add_student
# student2 = Student.new('Антонов', 'Иван', 'Борисович', { id: 1, telegram: '@ivan45' })
# id = student_list.add_student(student2)
# puts "New student id: #{id}"

# # Тест метода replace_student

# student_list.replace_student(4,student2)



# # Тест метода remove_student
# student_list.remove_student(5)
# deleted_student = student_list.student_by_id(id)
# puts "Удален студент"+deleted_student.inspect

app = FXApp.new
Window.new(app)
app.create
app.run



