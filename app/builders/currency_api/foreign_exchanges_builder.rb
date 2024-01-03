# frozen_string_literal: true

module CurrencyApi
  # Builder class in charge to interpretated
  # the data from the CurrencyAPI server
  # to the expected attributes that could be handle inside the application
  class ForeignExchangesBuilder
    attr_reader :instance

    def self.build(data_from_server)
      {
        code: data_from_server['code'],
        value: data_from_server['value'],
        last_updated_at: data_from_server['last_updated_at']
      }
    end
  end
end
