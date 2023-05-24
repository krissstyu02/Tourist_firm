# frozen_string_literal: true
class ClientList

  # конструктор
  def initialize(data_adapter)
    @data_adapter = data_adapter
  end

  # получить студента по id
  def client_by_id(client_id)
    @data_adapter.client_by_id(client_id)
  end


  #добавление студента
  def add_client(client)
    @data_adapter.add_client(client)
  end

  #отчисление студента
  def remove_client(client_id)
    @data_adapter.remove_client(client_id)
  end

  #замена студента
  def replace_client(client_id, client)
    @data_adapter.replace_client(client_id,client)
  end

  #подсчет количества студентов
  def client_count
    @data_adapter.client_count
  end

  #получение n элементов k страницы
  def get_k_n_client_short_list(k,n,data_list)
    @data_adapter.get_k_n_client_short_list(k,n,data_list)
  end
end
