# frozen_string_literal: true
require_relative '../models/client'
require 'logger'

class AddClientController

  def initialize(client_list)
    @client_list = client_list
    @logger = Logger.new('controller_add.log') # Указывает путь и имя файла для логов
  end

  #привязка view
  def add_view(view)
    @view = view
  end

  def execute
    @view.execute
    @logger.info('Executing add student operation')
  end

  def save_client(client)
    @logger.info('Saving client')
    @client_list.add_client(client)
  end


  def validate_fields(fields)
    @logger.info('Validating fields')
    required_fields = [:first_name, :paternal_name,:last_name] # список обязательных полей
    if required_fields.all? { |field| fields.key?(field) }
      client = Client.new(
        fields[:first_name],
        fields[:paternal_name],
        fields[:last_name],
        client_id: fields[:client_id] || nil,
        address: fields[:address] || nil,
        phone: fields[:phone] || nil,
        email: fields[:email] || nil
      )
      return client
    else
      return nil
    end
  rescue ArgumentError => e
    @logger.error("Error occurred while validating fields: #{e.message}")
    return nil
  end

end