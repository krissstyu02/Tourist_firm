require 'mysql2'
require_relative '../models/client'
require_relative '../models/client_short'
require_relative 'db_connection'

class ClientList_db_Adapter
  def initialize
    @db = DBConnection.instance
  end

  def client_by_id(client_id)
    client_id = client_id
    result = @db.query("SELECT * FROM client WHERE client_id = #{client_id.first.to_i}").first
    return Client.from_hash(result.transform_keys(&:to_sym)) if result
    nil
  end

  def add_client(client)
    result = @db.query("SELECT MAX(client_id) FROM client")
    next_id = result.map(&:to_h).first.values.first
    stmt = @db.prepare('INSERT INTO client (client_id, first_name, paternal_name, last_name, address, phone) VALUES (?, ?, ?, ?, ?, ?)')
    stmt.execute(next_id+1, *all_client_fields(client))
  end



  # def add_client(client)
  #   stmt = @db.prepare('INSERT INTO client (client_id,first_name, paternal_name, last_name,address, phone
  #   ) VALUES (?, ?, ?, ?, ?, ?)')
  #   stmt.execute(*all_client_fields(client))
  # end

  def remove_client(client_id)
    @db.query("DELETE FROM client WHERE client_id = #{client_id}")
  end



  def replace_client(client_id, client)
    fields = *client_fields(client)

    phone_value = fields[4].nil? ? 'NULL' : "'#{fields[4]}'"
    address_value = fields[3].nil? ? 'NULL' : "'#{fields[3]}'"


    @db.query("UPDATE client SET first_name = '#{fields[0]}',
                               paternal_name = '#{fields[1]}',
                               last_name = '#{fields[2]}',
                               address=#{address_value},
                               phone = #{phone_value}
                               WHERE client_id = #{client_id.first.to_i}")
  end





  def client_count
    @db.query('SELECT COUNT(client_id) FROM client').first.values.first
  end

  def get_k_n_client_short_list(k,n,data_list)
    clients = @db.query("SELECT * FROM client LIMIT #{(k-1)*n}, #{n}")
    clients2=clients.map(&:to_h)
    slice = clients2.map { |h| ClientShort.new(Client.from_hash(h.transform_keys(&:to_sym))) }
    DataListClientShort.new(slice) if data_list.nil?
    # student = student_list.student_by_id(1)
    # puts student.inspect
    data_list.replace_objects(slice)
    puts data_list
    data_list
  end

  private
  attr_accessor :client

  def client_fields(client)
    [client.first_name, client.paternal_name, client.last_name,client.address ,client.phone]
  end

  def all_client_fields(client)
    [client.first_name, client.paternal_name, client.last_name,client.address ,client.phone]
  end
end

