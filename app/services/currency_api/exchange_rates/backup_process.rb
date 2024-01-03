module CurrencyApi
  module ExchangeRates
    class BackupProcess
      include ServiceBehavior

      attr_reader :args

      def initialize(args = {})
        @args = args
      end

      def perform
        records = fetch_records
        backup_records(records.values)
      rescue StandardError => e
      end

      private

      def fetch_records
        currency_api_service.perform['data']
      end

      def currency_api_service
        @currency_api_service ||= CurrencyApi::ExchangeRates::GetService.new
      end

      def backup_records(records)
        return if records.empty?
        list_exchanges = []

        records.each do |record|
          current_datetime = DateTime.current
          list_exchanges << ForeignExchangesBuilder.
            build(record.merge!('last_updated_at' => record['last_updated_at'])).
            merge!(created_at: current_datetime, updated_at: current_datetime)
        end

        ForeignExchange.upsert_all(list_exchanges) unless list_exchanges.empty?
      end
    end
  end
end