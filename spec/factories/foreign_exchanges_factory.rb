# frozen_string_literal: true

FactoryBot.define do
  factory :foreign_exchange do
    code { 'AFN' }
    value { 70.0343120125 }
    last_updated_at { DateTime.current }
  end
end
