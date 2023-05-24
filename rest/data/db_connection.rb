# frozen_string_literal: true

require 'mysql2'

# Здесь создается класс DBConnection с помощью Ruby-модуля Singleton.
# Это означает, что экземпляр этого класса может быть создан только один раз.
class DBConnection
  require 'singleton'
  include Singleton

  #подключения к базе данных student_db
  def initialize
    db_config = {
      host: 'localhost',
      username: 'root',
      password: 'Kris110902Star',
      database: 'tourist_firm'
    }
    @client = Mysql2::Client.new(db_config)
  end

  #запросы к базе данных
  def query(sql)
    @client.query(sql)
  end



  #запросы к базе данных,
  def prepare(sql)
    @client.prepare(sql)
  end
  #возвращает идентификатор последней вставленной записи.
  def last_id
    @client.last_id
  end
end