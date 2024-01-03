# frozen_string_literal: true

if @query.result_code == 200
  json.result @query.result do |foreign_exchange|
    json.code foreign_exchange.code
    json.value foreign_exchange.value
    json.last_updated_at format_last_updated_at(foreign_exchange.last_updated_at)
  end
else
  json.message @query.errors.full_messages.join(', ')
  json.result_code @query.result_code
end
