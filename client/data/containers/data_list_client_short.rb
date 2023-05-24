# frozen_string_literal: true

require_relative 'DataList'
require_relative 'dataTable'
class DataListClientShort < DataList
    public_class_method :new

  def get_names
    ["last_name_and_initials","address", "contact"]
    end

  def get_data
      result = []
      id = 0
      objects_list.each do |obj|
        row = []
        row << id
        row.push(*table_fields(obj))
        result << row
        id += 1
      end
      DataTable.new(result)
  end

  protected
    #сеттер для массива объектов
  def table_fields(object)
    [object.last_name_and_initials,object.address, object.contact]
  end
end