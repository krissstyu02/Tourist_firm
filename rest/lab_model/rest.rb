# frozen_string_literal: true
require 'date';

class Rest

  def initialize(rest_id: nil, tour: nil, duration: nil,price:nil)
    raise ArgumentError, "Required fields: id, tour duration,price!" if rest_id.nil? ||
      tour.nil?|| duration.nil? || price.nil?
    @rest_id = rest_id
    @tour = tour
    @duration = duration
    @price = price
  end

  attr_reader :rest_id, :tour,:duration,:price


  def to_s
    res = "#{rest_id} #{tour} #{duration} #{price}"
  end

  def self.validate_tour(tour)
    # Проверка на наличие только букв и цифр
    /^[[:alnum:]]+$/.match?(tour)
  end

  def self.validate_duration(duration)
    # Проверка на наличие только букв и цифр
    /^[[:alnum:]]+$/.match?(duration)
  end

  def self.validate_price(price)
    # Проверка на наличие только цифр и десятичных точек (для стоимости в формате целое число или десятичная дробь)
    /^\d+(\.\d+)?$/.match?(price)
  end



  def to_hash
    info_hash = {}
    %i[rest_id tour duration price ].each do |field|
      info_hash[field] = send(field)
    end
    info_hash
  end

end
