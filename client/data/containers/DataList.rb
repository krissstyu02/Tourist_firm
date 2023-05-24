# frozen_string_literal: true

class DataList

  private_class_method :new
  #Реализовать сеттер для массива объектов
  attr_writer :objects_list

  def initialize(objects)
    self.objects_list = objects
    self.selected_objects = []
    @observers = []
  end

  def add_observer(observer)
    @observers.append(observer)
  end

  def notify
    @observers.each { |observer| observer.on_datalist_changed(get_data) }
  end

  def select(number)
    selected_objects.append(number)
  end

  def clear_select
    self.selected_objects = []
  end

  def get_select
    selected_objects.inject([]) {|res, index| res<<objects_list[index].client_id}
  end

  def clear_selected
    self.selected_objects = []
  end

  def get_names; end

  # def get_selected
  #   return [] if selected_objects.empty?
  #
  #   selected_id_list = []
  #   selected_objects.each do |num|
  #     selected_id_list.append(objects_list[num].id)
  #   end
  #   selected_id_list
  # end

# применение паттерна
  def get_data
    index_id=0
    dt = objects_list.inject([]) do |res, object|
      row=[index_id]
      row.append(*get_fields(object))
      index_id+=1
      res<<row
    end
    DataTable.new(dt)
  end

#данный метод необходимо переопределять у наследников
def table_fields(object)
  []
end

  def replace_objects(objects_list)
    self.objects_list=objects_list.dup
    notify
  end



  private
attr_reader :objects_list
attr_accessor :selected_objects
end