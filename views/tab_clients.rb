
require 'fox16'
include Fox
require_relative '../controller/controller'
class TabClient<FXVerticalFrame
  def initialize(p, *args, &blk)
    super
    @clients_on_page=2
    @current_page=1
    @count_client=0
    @controller = ClientListController.new(self)
    first_tab
  end

  def update_count_clients(count_client)
    @count_client = count_client
    update_page_label
  end

  def self.update_data_table(table_self, new_table)
    row_number=0
    (0...table_self.getNumRows).each do |row|
      (0...table_self.getNumColumns).each do |col|
        table_self.setItemText(row, col, "")
      end
    end
    new_table.each do |row|
      (1..2).each { |index_field| table_self.setItemText(row_number, index_field-1, row[index_field].to_s)  }
      row_number+=1
    end
  end

  def refresh
    @controller.refresh_data(@current_page, @clients_on_page)
  end

  def on_datalist_changed(table)
    TabClient.update_data_table(@table, table)
  end


  def first_tab
    add_filters
    add_table
  end

  def add_filters
    # Filter
    frame_filter = FXVerticalFrame.new(self, :padTop=>50)
    frame_filter.resize(500, 300)

    field_filter = [  [:address, "Адрес"],
                      [:phone, "Телефон"]
    ]

    # ФИЛЬТР ИМЕНИ
    name_label = FXLabel.new(frame_filter, "Фамилия и инициалы")
    name_text_field = FXTextField.new(frame_filter, 64)
    @filter = { short_name: name_text_field }


    # Фильтрация для остальных полей
    field_filter.each do |field|
      @filter[field[0]] = create_radio_group(field, frame_filter)

    end

    btn_clear = FXButton.new(frame_filter, "Очистить", :opts=>BUTTON_NORMAL)
  end



  def add_table
    # Создаем главный вертикальный фрейм для таблицы и элементов управления страницами
    table_frame = FXVerticalFrame.new(self, :padTop=>50)
    # table_frame.resize(1000, 900)

    # Создаем горизонтальный фрейм для элементов управления страницами
    page_controls = FXHorizontalFrame.new(table_frame, :opts => LAYOUT_CENTER_X)
    # Создаем кнопку "Назад"
    btn_back = FXButton.new(page_controls, "Назад", :opts => BUTTON_NORMAL | LAYOUT_CENTER_Y | LAYOUT_LEFT)
    btn_back.backColor = FXRGB(255, 255, 255)
    btn_back.textColor = FXRGB(0, 0, 0)
    btn_back.font = FXFont.new(app, "Arial", 10, :weight => FONTWEIGHT_BOLD)

    #номер страницы
    change_page = FXHorizontalFrame.new(page_controls, :opts=> LAYOUT_CENTER_X)
    @page_label = FXLabel.new(change_page, '1')
    @page_label.font = FXFont.new(app, "Arial", 10, :weight => FONTWEIGHT_BOLD)

    # Создаем кнопку "Далее"
    btn_next = FXButton.new(page_controls, "Далее", :opts => BUTTON_NORMAL | LAYOUT_CENTER_Y | LAYOUT_RIGHT)
    btn_next.backColor = FXRGB(255, 255, 255)
    btn_next.textColor = FXRGB(0, 0, 0)
    btn_next.font = FXFont.new(app, "Arial", 10, :weight => FONTWEIGHT_BOLD)


    # Создаем таблицу
    @table = FXTable.new(table_frame,
                         :opts => TABLE_READONLY | LAYOUT_FIX_WIDTH | LAYOUT_FIX_HEIGHT | TABLE_COL_SIZABLE | TABLE_ROW_RENUMBER,
                         :width => 700, :height => 250)
    @table.setTableSize(10, 2)
    @table.setTableSize(@clients_on_page, 2)
    @table.backColor = FXRGB(255, 255, 255)
    @table.textColor = FXRGB(0, 0, 0)


    # Задаем названия столбцов таблицы
    @table.setColumnText(0, "ФИО")
    @table.setColumnText(1, "Контакт")

    # Масштабируем таблицу
    @table.setRowHeaderWidth(50)
    @table.setColumnWidth(0, 350)
    @table.setColumnWidth(1, 300)


    # Создаем обработчик событий для сортировки таблицы по столбцу при нажатии на заголовок столбца
    @table.getColumnHeader.connect(SEL_COMMAND) do |a, b, col|
      sort_table_by_column(@table, col)
    end


    page_controls2 = FXHorizontalFrame.new(table_frame, :opts => LAYOUT_CENTER_X)
    # Создаем кнопку "Добавить"
    btn_add = FXButton.new(page_controls2, "Добавить", :opts => BUTTON_NORMAL | LAYOUT_CENTER_Y)
    btn_add.backColor = FXRGB(255, 255, 255)
    btn_add.textColor = FXRGB(0, 0, 0)
    btn_add.font = FXFont.new(app, "Arial", 10, :weight => FONTWEIGHT_BOLD)


    # Создаем кнопку "Удалить"
    btn_delete = FXButton.new(page_controls2, "Удалить", :opts => BUTTON_NORMAL | LAYOUT_CENTER_Y)
    btn_delete.backColor = FXRGB(255, 255, 255)
    btn_delete.textColor = FXRGB(0, 0, 0)
    btn_delete.font = FXFont.new(app, "Arial", 10, :weight => FONTWEIGHT_BOLD)

    combo_change = FXComboBox.new(page_controls2, 20, :opts=>  FRAME_SUNKEN|FRAME_THICK|LAYOUT_SIDE_TOP|LAYOUT_FILL_X)
    # Создаем кнопку "Обновить"
    btn_refresh = FXButton.new(page_controls2, "Обновить", :opts => BUTTON_NORMAL | LAYOUT_CENTER_Y)
    btn_refresh.backColor = FXRGB(255, 255, 255)
    btn_refresh.textColor = FXRGB(0, 0, 0)
    btn_refresh.font = FXFont.new(app, "Arial", 10, :weight => FONTWEIGHT_BOLD)

    # Создаем обработчик событий для сброса выделения при переключении страниц
    page_controls.connect(SEL_COMMAND) do
      @table.killSelection
    end


    # Делаем кнопки изменить и удалить неактивными по умолчанию
    btn_delete.disable
    combo_change.disable

    combo_change.appendItem("Изменить ФИО")
    combo_change.appendItem("Изменить контакт")

    # обработчик
    @table.connect(SEL_CHANGED) do
      num_selected_rows = 0
      (0...@table.getNumRows()).each { |row_index| num_selected_rows+=1 if @table.rowSelected?(row_index)}

      # Если выделена только одна строка, кнопка должна быть неактивной
      if num_selected_rows == 1
        combo_change.enable
        btn_delete.enable
        # Если выделено несколько строк, кнопка должна быть активной
      elsif num_selected_rows >1
        combo_change.disable
        btn_delete.enable
      end
    end

    @table.getRowHeader.connect(SEL_RIGHTBUTTONPRESS) do
      @table.killSelection(true)
      combo_change.disable
      btn_delete.disable
    end

    btn_add.connect(SEL_COMMAND) do
      @controller.client_add
    end

    btn_refresh.connect(SEL_COMMAND) do
      @controller.refresh_data(@current_page, @clients_on_page)
    end

    btn_back.connect(SEL_COMMAND) do
      if @current_page!=1
        @current_page-=1
        refresh
        update_page_label
      end
    end
    btn_next.connect(SEL_COMMAND) do
      if @current_page<(@count_client / @clients_on_page.to_f).ceil
        @current_page+=1
        refresh
        update_page_label
      end
    end

    combo_change.connect(SEL_COMMAND) do
      index = (0...@table.getNumRows).find {|row_index| @table.rowSelected?(row_index)}
      case combo_change.currentItem
      when 0
        @controller.client_change_name(index)
      when 1
        @controller.client_change_contact(index)
      end
    end



    btn_delete.connect(SEL_COMMAND) do
      indexes = (0...@table.getNumRows).select{|row_index| @table.rowSelected?(row_index)}
      @controller.client_delete(indexes)
    end

  end

  #сортировка таблицы по столбцу
  def sort_table_by_column(table, column_index)
    table_data = []
    (0...table.getNumRows()).each do |row_index|
      if table.getItemText(row_index, column_index)!=''
        row=[]
        (0...table.getNumColumns()).each do |col_index|
          row[col_index] = table.getItemText(row_index, col_index)
        end
        table_data<<row
      end
    end
    sorted_table_data = table_data.sort_by { |row_data| row_data[column_index] }
    sorted_table_data.each_with_index do |row_data, row_index|
      row_data.each_with_index do |cell_data, col_index|
        table.setItemText(row_index, col_index, cell_data)
      end
    end
  end

  def create_radio_group(field, parent)
    #Фильтрация гита
    frame_field = FXVerticalFrame.new(parent, LAYOUT_FILL_X||LAYOUT_SIDE_TOP)
    label_field = FXLabel.new(frame_field, field[1])
    line_radio = FXHorizontalFrame.new(frame_field, LAYOUT_FILL_X|LAYOUT_SIDE_TOP)
    # Создаем radiobutton
    radio_yes = FXRadioButton.new(line_radio, "Да")
    radio_no = FXRadioButton.new(line_radio, "Нет")
    radio_no_matter = FXRadioButton.new(line_radio, "Не важно")
    #фильтр
    text_field = FXTextField.new(line_radio, 40)
    #прописываем доступность(тоже обработчик)
    text_field.setEnabled(false)
    radio_yes.connect(SEL_COMMAND) do
      radio_no.check=false
      radio_no_matter.check=false
      if radio_yes.checked?
        text_field.setEnabled(true)
      end
    end
    radio_no.connect(SEL_COMMAND) do
      radio_no_matter.check=false
      radio_yes.check=false
      if radio_no.checked?
        text_field.setEnabled(false)
      end
    end
    radio_no_matter.connect(SEL_COMMAND) do
      radio_no.check=false
      radio_yes.check=false
      if radio_no_matter.checked?
        text_field.setEnabled(false)
      end
    end
    frame_field
  end


  def update_page_label
    @page_label.text = "#{@current_page} / #{(@count_client / @clients_on_page.to_f).ceil}"
  end


end


