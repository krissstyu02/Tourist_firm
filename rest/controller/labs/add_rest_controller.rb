# frozen_string_literal: true

require_relative '../../lab_model/rest';

class AddRestController
  def initialize(restdb)
    @restdb = restdb
  end

  def add_view(view)
    @view = view
    @view.set_rest
  end
  def execute
    @view.execute
  end
  def save_rest(rest)
    @restdb.add_rest(rest)
  end

  def next_number_rest
    @restdb.get_next_number
  end

  def validate_fields(fields)
    begin
      rest = Rest.new(**fields)
      return rest

    rescue ArgumentError => e
      return nil
    end
  end

  def validate_duration(duration)
    return Rest.validate_duration(duration)

  end

  def validate_tour(tour)
    return Rest.validate_tour(tour)
  end

  def validate_price(price)
    return  Rest.validate_price(price)

  end
end