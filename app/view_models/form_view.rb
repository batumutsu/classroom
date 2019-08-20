# frozen_string_literal: true

class FormView < ViewModel
  attr_reader :subject, :organization

  def errors_for?(field)
    subject.errors[field].present?
  end

  def error_message_for(field)
    subject.errors.full_messages_for(field).join(", ")
  end

  def form_class_for(field)
    "form-group#{errors_for?(field) ? ' errored primer-new' : ''}"
  end

  def error_message_for_object(object)
    object.errors.full_messages.join(", ")
  end

  def errors_for_object?(object)
    object&.errors.present?
  end

  def private_repos_available?
    return @private_repos_available if @private_repos_available

    begin
      plan = organization.plan
    rescue GitHub::Error => error
      raise Result::Error, error.message
    end

    @private_repos_available = plan[:owned_private_repos] < plan[:private_repos]
  end
end
