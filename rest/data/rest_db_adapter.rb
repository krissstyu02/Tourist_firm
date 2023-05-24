# frozen_string_literal: true

require_relative 'db_connection'


class RestDbAdapter
  def initialize
    self.db =DBConnection.instance
  end

  def get_rest_by_id(rest_id); end
  def add_rest(rest); end
  def remove_rest(rest_id);end
  def replace_rest(rest_id, rest); end
  def get_rest_list; end #получение все лаб в базе
end