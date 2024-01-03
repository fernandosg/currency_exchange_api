module CurrencyApi
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