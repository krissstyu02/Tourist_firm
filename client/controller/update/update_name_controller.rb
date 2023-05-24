# frozen_string_literal: true

require_relative '../update_controller'
class ChangeClientNameController<UpdateClientController
  public_class_method :new
  def get_editable_fields
    [:last_name, :paternal_name,:first_name]
  end

end