# frozen_string_literal: true
#
require_relative '../views/interface'
require_relative '../data/client_list'
require_relative '../data/client_db_adapter'
require_relative '../data/containers/data_list_client_short'
require_relative 'add_controller'
require_relative '../views/dialog_create_client'
require_relative '../models/client'
require_relative 'update_controller'
require_relative 'update/update_name_controller'
require_relative 'update/update_contact_controller'
require 'fox16'
include Fox
require 'logger'


class ClientListController
  def initialize(view)
    @view = view
    @data_list = DataListClientShort.new([])
    @data_list.add_observer(@view)
    @client_list = ClientList.new(ClientList_db_Adapter.new)
    @logger = Logger.new('controller.log') # Указывает путь и имя файла для логов
  end




  def refresh_data(k_page, number_clients)
    begin
    @logger.info("Refreshing data with k_page=#{k_page} and number_clients=#{number_clients}")
    @data_list = @client_list.get_k_n_client_short_list(k_page, number_clients, @data_list)
    rescue Mysql2::Error => e
      @logger.error("Error occurred while refreshing data: #{e.message}")
      puts "No connection to DB: #{e.message}"
      exit(false)
    else
      @logger.info("Data refreshed successfully with k_page=#{k_page} and number_clients=#{number_clients}")
  end
    @view.update_count_clients(@client_list.client_count)
  end


  def client_add
    @logger.info('Add client')
    controller = AddClientController.new(@client_list)
    show_dialog(controller)
  end

  private
  #изменение студента
  def get_client_id(index)
    @data_list.select(index)
    id = @data_list.get_select
    @data_list.clear_selected
    id
  end

  public
  def client_change_name(index)
    @logger.info('Changing client name')
    puts 'update name'
    id = get_client_id(index)
    controller = ChangeClientNameController.new(@client_list, id)
    show_dialog(controller)
  end


  def client_change_contact(index)
    @logger.info('Changing client contact')
    puts 'update contact'
    id = get_client_id(index)
    controller = ChangeClientContactController.new(@client_list, id)
    show_dialog(controller)
  end


  def client_delete(indexes)
    @data_list.select(*indexes)
    id_list = @data_list.get_select
    @data_list.clear_selected

    id_list.each{|client_id| @client_list.remove_client(client_id)}
    @view.refresh
    @logger.info("Deleted client with IDs: #{id_list.join(', ')}")
  end

  private
  def show_dialog(controller)
    # controller = AddStudentController.new(@student_list)
    view = CreateClientDialog.new(@view, controller)
    controller.add_view(view)
    controller.execute
    @view.refresh
  end


end
