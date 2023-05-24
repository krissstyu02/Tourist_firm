# frozen_string_literal: true
require_relative '../../models/rest_db'
require_relative '../../data/containers/data_list_rest'
require_relative 'add_rest_controller'
require_relative '../../views/create_rest_dialog'
require_relative 'change_rest_controller'


class RestController
  def initialize(view)
    @view = view
    @data_list  = DataListRest.new([])
    @data_list.add_observer(@view)
    @restdb= RestDb.new
  end

  def refresh_data
    begin
      @data_list = @restdb.get_rest_list(@data_list)
    rescue Mysql2::Error => e
      puts "No connection to DB: #{e.message}"
      exit(false)
    end
  end

  def add_rest
    controller = AddRestController.new(@restdb)
    show_dialog(controller)
  end

  def show_dialog(controller)
    view = CreateRestDialog.new(@view, controller)
    controller.add_view(view)
    controller.execute

    @view.refresh
  end

  def get_count_rest
    @restdb.rest_count
  end
  def delete_rest
    @restdb.remove_rest(get_count_rest)
    @view.refresh
  end

  def update_rest(index)
    @data_list.select(index)
    id = @data_list.get_select
    @data_list.clear_selected

    controller = ChangeRestController.new(@restdb, id)
    show_dialog(controller)
  end

  end
