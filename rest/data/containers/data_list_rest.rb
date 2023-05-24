# frozen_string_literal: true
require_relative 'DataList'
require_relative 'dataTable'

class DataListRest<DataList
  public_class_method :new

  protected
  def get_fields(object)
    [ object.tour, object.duration,object.price]
  end

end
