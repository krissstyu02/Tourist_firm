# frozen_string_literal: true

require_relative '../lab_model/rest'
require_relative '../data/containers/data_list_rest'
require_relative '../data/db_connection'

class RestDb
  def initialize
    self.db =DBConnection.instance
  end

  def get_rest_by_number(rest_id)
    rest = Array(rest_id)
    result = @db.query("SELECT * FROM rest WHERE rest_id = #{rest_id.first.to_i}")
    hash = result.first
    puts hash

    return nil if hash.nil?
    Rest.new(**hash.transform_keys(&:to_sym))
  end




  def add_rest(rest)
    # db.query('insert into labs (number, name, date_load) VALUES (?, ?, ?)', *lab_fields(lab)).first
    stmt = db.prepare('INSERT INTO rest (rest_id,tour,duration,price) VALUES (?,?,?, ?)')
    puts(*rest_fields(rest))
    stmt.execute(*rest_fields(rest))

  end

  def remove_rest(rest_id)
    db.query("DELETE FROM rest WHERE rest_id = #{rest_id}")
  end


  def replace_rest(rest_id, rest)
    fields = *rest_fields(rest)
    tour = fields[1].nil? ? 'NULL' : fields[1]
    duration = fields[2].nil? ? 'NULL' : "'#{fields[2]}'"
    price = fields[3].nil? ? 'NULL' : fields[3]

    db.query("UPDATE rest SET tour = '#{tour}',
                             duration = #{duration},
                             price = '#{price}'

                             WHERE rest_id = #{rest_id.first.to_i}")
  end




  # def replace_lab(id_lab, lab)
  #   sql = 'UPDATE labs SET name=?, date_load=? themes=? tasks=? WHERE id=?'
  #   fields=*lab_fields(lab)
  #   db.prepare(sql).execute(fields[1],fields[2],fields[3], fields[4], id_lab)
  # end



  def get_rest_list(data_list=nil) #получение все лаб в базе
    rest_hash = db.query('SELECT * FROM rest')
    rest = rest_hash.map{|rest| Rest.new(**rest.transform_keys(&:to_sym))}
    return DataListRest.new(rest) if data_list.nil?
    data_list.replace_objects(rest)
    data_list
  end

  def get_next_number
    rest_count+1
  end

  def rest_count
    res=db.query('SELECT COUNT(rest_id) FROM rest').first.values.first
    res
  end

  private
  attr_accessor :db

  def rest_fields(rest)
    [rest.rest_id, rest.tour, rest.duration,rest.price]
  end
end