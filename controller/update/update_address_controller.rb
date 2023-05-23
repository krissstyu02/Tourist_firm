# frozen_string_literal: true
require_relative '../update_controller'
class ChangeClientAddressController<UpdateClientController
  public_class_method :new
  def get_editable_fields
    [:address]
  end

end
