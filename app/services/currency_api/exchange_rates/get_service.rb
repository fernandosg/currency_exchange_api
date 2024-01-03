# frozen_string_literal: true

module CurrencyApi
  module ExchangeRates
    # Service class in charge to request the latest currency to the CurrencyApi
    class GetService < ::CurrencyApi::BaseService
      def perform
        request_get
      end

      def resource_url
        'latest'
      end
    end
  end
end
