# frozen_string_literal: true
require 'fox16'
include Fox
require_relative '../controller/labs/rest_controller'


class TabRest<FXVerticalFrame
  def initialize(parent, *args, &blk)
    super
    @controller = RestController.new(self)
    add_table
  end

  def add_table
    table_frame = FXVerticalFrame.new(self, :padLeft=>20)
    # page_change_buttons(table_frame)
    # Создаем таблицу
    @table = FXTable.new(table_frame, :opts =>  TABLE_READONLY|LAYOUT_FIX_WIDTH|LAYOUT_FIX_HEIGHT|TABLE_COL_SIZABLE|TABLE_ROW_RENUMBER, :width=>800, :height=>400)
    @table.setTableSize(16, 3)


    @table.setColumnText(0, "Тур")
    @table.setColumnText(1, "Длительность")
    @table.setColumnText(2, "Цена")

    # Масштабируем таблицу
    @table.setRowHeaderWidth(30)
    @table.setColumnWidth(0, 300)
    @table.setColumnWidth(1, 250)
    @table.setColumnWidth(2, 217)


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


    # Создаем кнопку "Обновить"
    btn_refresh = FXButton.new(page_controls2, "Обновить", :opts => BUTTON_NORMAL | LAYOUT_CENTER_Y)
    btn_refresh.backColor = FXRGB(255, 255, 255)
    btn_refresh.textColor = FXRGB(0, 0, 0)
    btn_refresh.font = FXFont.new(app, "Arial", 10, :weight => FONTWEIGHT_BOLD)


    # Создаем кнопку "Изменить"
    btn_remove = FXButton.new(page_controls2, "Изменить", :opts => BUTTON_NORMAL | LAYOUT_CENTER_Y)
    btn_remove.backColor = FXRGB(255, 255, 255)
    btn_remove.textColor = FXRGB(0, 0, 0)
    btn_remove.font = FXFont.new(app, "Arial", 10, :weight => FONTWEIGHT_BOLD)


    btn_delete.disable
    btn_remove.disable

    @table.connect(SEL_CHANGED) do
      num_selected_rows = 0
      (0...@table.getNumRows()).each { |row_index| num_selected_rows+=1 if @table.rowSelected?(row_index)}

      # Если выделена только одна строка, кнопка должна быть неактивной
      if num_selected_rows >= 1
        btn_remove.enable
        if @table.rowSelected?(@controller.get_count_rest-1) and num_selected_rows ==1
          btn_delete.enable
          end
        # Если выделено несколько строк, кнопка должна быть активной
      elsif num_selected_rows ==0
        btn_remove.disable
        btn_delete.disable
      end
    end

    @table.getRowHeader.connect(SEL_RIGHTBUTTONPRESS) do
      @table.killSelection(true)
      btn_remove.disable
      btn_delete.disable
    end

    btn_refresh.connect(SEL_COMMAND) do
      refresh
    end

    btn_add.connect(SEL_COMMAND) do
      @controller.add_rest
    end

    btn_delete.connect(SEL_COMMAND) do
      @controller.delete_rest
      @table.killSelection
    end

    btn_remove.connect(SEL_COMMAND) do
      index = (0...@table.getNumRows).find {|row_index| @table.rowSelected?(row_index)}
      @controller.update_rest(index)
    end



  end

  def refresh
    @controller.refresh_data
  end


  def self.update_data_table(table_self, new_table)
    row_number=0
    (0...table_self.getNumRows).each do |row|
      (0...table_self.getNumColumns).each do |col|
        table_self.setItemText(row, col, "")
      end
    end
    new_table.each do |row|
      (1..3).each { |index_field| table_self.setItemText(row_number, index_field-1, row[index_field].to_s)  }
      row_number+=1
    end
  end

  def on_datalist_changed(table)
    TabRest.update_data_table(@table, table)
  end

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

  end

