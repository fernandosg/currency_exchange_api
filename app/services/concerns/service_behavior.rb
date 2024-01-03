# frozen_string_literal: true

# Concern to handle a the necessary includes to manage specific service class
# with the behavior as model that allows to define validations logic, for
# examples for attributes
module ServiceBehavior
  extend ActiveSupport::Concern
  include ActiveModel::Model
  include ActiveModel::Validations

  def success?
    errors.empty? && valid?
  end
end
