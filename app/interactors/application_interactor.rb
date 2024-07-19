# frozen_string_literal: true

class ApplicationInteractor
  include Interactor

  protected

  def store_missing_parameter_error
    context.errors = context.errors || []
    context.errors << { error: "Falta parametros para o 'Interactor #{self.class.name}'" }
    context.fail!
  end

  def add_error_and_fail(error_message)
    context.errors = context.errors || []
    context.errors << { error: error_message }
    context.fail!
  end
end
