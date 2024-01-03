module ServiceBehavior
  extend ActiveSupport::Concern
  include ActiveModel::Model
  include ActiveModel::Validations

  def success?
    errors.empty? && valid?
  end
end