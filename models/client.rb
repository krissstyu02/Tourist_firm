require 'json'
require_relative 'client_short'

class Client < ClientShort
  # стандартные геттеры и сеттеры для класса
  attr_writer :client_id
  attr_reader :first_name,:paternal_name,:last_name,:address,:phone,:email

  # валидаТОР номера телефона
  def self.valid_phone?(phone)
    /\A\+?[7,8] ?\(?\d{3}\)?-?\d{3}-?\d{2}-?\d{2}\z/.match?(phone)
  end

  def self.valid_name?(name)
    /\A[А-Я][а-я]+\z/.match?(name)
  end

  def self.valid_address?(address)
    return false if address.split.length.zero?
    # return false unless /[0-9]/.match?(address)
    # return false unless /^[a-zA-Z0-9а-яА-Я\s.,-]+$/.match?(address)
    true
  end

  def self.valid_email?(email)
    /\A[A-Za-z0-9\-_]+@[A-Za-z]+\.([A-Za-z]+\.)*[A-Za-z]+\z/.match?(email)
  end


  # стандартный конструктор
  def initialize(first_name, paternal_name, last_name, client_id: nil, address: nil, phone: nil,email:nil)
    self.first_name = first_name
    self.paternal_name = paternal_name
    self.last_name = last_name
    self.client_id = client_id
    self.address = address
    set_contacts(phone:phone,email:email)
  end


  # конструктор из json-строки
  def self.init_from_json(str)
    params = JSON.parse(str, { symbolize_names: true })
    from_hash(params)
  end

  #конструктор принимающий хэш
  def self.from_hash(hash)
    raise ArgumentError, 'Missing fields: first_name, paternal_name,last_name' unless hash.key?(:first_name) && hash.key?(:paternal_name) && hash.key?(:last_name)

    first_name = hash.delete(:first_name)
    paternal_name = hash.delete(:paternal_name)
    last_name = hash.delete(:last_name)

    Client.new(first_name, paternal_name,last_name, **hash)
  end

  def to_hash
    info_hash = {}
    %i[first_name paternal_name last_name client_id  address phone email ].each do |field|
      info_hash[field] = send(field) unless send(field).nil?
    end
    info_hash
  end


  #сеттеры
  def phone=(phone)
    raise ArgumentError, "Incorrect value: phone=#{phone}!" if !phone.nil? && !Client.valid_phone?(phone)
    @phone = phone
  end

  def first_name=(first_name)
    raise ArgumentError, "Incorrect value: first_name=#{first_name}!" if !first_name.nil? && !Client.valid_name?(first_name)

    @first_name = first_name
  end

  def last_name=(last_name)
    raise ArgumentError, "Incorrect value: last_name=#{last_name}" if !last_name.nil? && !Client.valid_name?(last_name)

    @last_name = last_name
  end

  def paternal_name=(paternal_name)
    raise ArgumentError, "Incorrect value: paternal_name=#{paternal_name}!" if !paternal_name.nil? && !Client.valid_name?(paternal_name)

    @paternal_name = paternal_name
  end


  def address=(address)
    raise ArgumentError, "Incorrect value: address=#{address}!" if !address.nil? && !Client.valid_address?(address)

    @address = address
  end

  def email=(email)
    raise ArgumentError, "Incorrect value: address=#{email}!" if !email.nil? && !Client.valid_email?(email)

    @email = email
  end

  # метод возвращающий фамилию и инициалы у объекта
  def last_name_and_initials
    "#{last_name} #{first_name[0]}. #{paternal_name[0]}."
  end

  # метод возвращающий краткую инф-ю об объекте
  def short_info
    "#{short_name}, #{contact},#{address}"
  end


  # метод устанавливающий контакт
  def contact
    return @contact = "phone= #{phone}" unless phone.nil?
    return @contact = "email= #{email}" unless email.nil?

    nil
  end


  def set_contacts(phone: nil,email:nil)
    self.phone = phone if phone
    self.email = email  if email
  end

  # метод возвращающий представление объекта в виде строки
  def to_s
    result = "#{first_name} #{paternal_name}#{last_name}"
    result += " client_id=#{client_id}" unless client_id.nil?
    result += " #{address}" unless address.nil?
    result += " phone=#{phone}" unless phone.nil?
    result += " email=#{email}" unless email.nil?
    result
  end

end