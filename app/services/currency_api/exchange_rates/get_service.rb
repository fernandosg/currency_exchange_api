module CurrencyApi
  module ExchangeRates
    class GetService < ::CurrencyApi::BaseService
      def perform
        get_request
      end

      def resource_url
        'latest'
      end
    end
  end
end