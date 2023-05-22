require 'json'
require_relative 'client'

class ClientShort
  # стандартные геттеры для класса
  attr_reader :client_id, :contact, :last_name, :initials

  # стандартный конструктор, принимающий аргументов экземпляр класса student
  def initialize(student)
    @client_id = student.client_id
    @last_name = student.last_name
    @initials = "#{student.first_name[0]}. #{student.paternal_name[0]}."
    @contact = student.contact
  end

  # кастомный конструктор, принимающий на вход id и строку, которая содержит всю остальную инф-ю
  def self.from_str(id, str)
    result = JSON.parse(str)
    raise ArgumentError, 'Missing fields: first_name, paternal_name , last_name' unless result.key?('first_name') && result.key?('paternal_name') && result.key?('last_name')

    ClientShort.new(Client.new(result['first_name'],result['paternal_name'],
                               result['last_name'],client_id: client_id,
                               address:result['address'], phone: result['phone'],))
  end

  # метод возвращающий фамилию и инициалы у объекта
  def last_name_and_initials
    "#{@last_name} #{@initials}"
  end

  # метод возвращающий представление объекта в виде строки
  def to_s
    result = last_name_and_initials
    result += " client_id= #{client_id} " unless client_id.nil?
    result += contact unless contact.nil?
    result
  end


  # метод проверяющий наличие контакта
  def contact?
    !contact.nil?
  end

  def validate?
    contact?
  end

  private

  # def set_contacts(contacts)
  #   return @contact = contacts['phone'] if contacts.key?('phone')
  #   return @contact = contacts['telegram'] if contacts.key?('telegram')
  #   @contact = contacts['email'] if contacts.key?('email')
  # end

end