# frozen_string_literal: true

class DataTable

  attr_reader :rows_count, :cols_count

  def initialize(table)

    self.rows_count = table.length
    max_cols = 0
    table.each do |row|
      max_cols = row.length if row.size > max_cols
    end
    self.cols_count = max_cols
    self.table = table
  end

  #получить элемент по номеру
  def get_element(row, col)
    return nil if row >= rows_count || row.negative?
    return nil if col >= cols_count || col.negative?

    table[row][col]
  end

  def each(&block)
    table.each do |row|
      block.call(row)
    end
  end

  def to_s
    table.map { |row| "[#{row.join(', ')}]" }.join("\n")
  end

  private
  attr_accessor :table
  attr_writer :rows_count, :cols_count

end

table = DataTable.new([
                        [1, 2, 4],
                        [1, 2, 3],
                        [4, 5, 6]
                      ])

puts table.get_element(2, 2) # выводит значение элемента на пересечении второй строки и