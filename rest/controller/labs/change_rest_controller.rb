# frozen_string_literal: true
require_relative 'add_rest_controller'

class ChangeRestController<AddRestController
  def initialize(restdb, rest_id)
    super(restdb)
    @rest_number = rest_id
  end

  def add_view(view)
    @view = view
    rest = @restdb.get_rest_by_number(@rest_number)
    @view.set_rest(rest)
  end

  def save_rest(rest)
    @restdb.replace_rest(@rest_number, rest)
  end
end
