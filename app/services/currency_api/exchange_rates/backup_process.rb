# frozen_string_literal: true

module CurrencyApi
  module ExchangeRates
    # Service class in charge to fetch the information from CurrencyAPI
    # and insert in the local db
    class BackupProcess
      include ServiceBehavior

      attr_reader :args, :last_updated_at

      def initialize(args = {})
        @args = args
      end

      def perform
        records = fetch_records
        backup_records(records.values)
      rescue StandardError => e
        errors.add(:base, e.message)
        nil
      end

      private

      def fetch_records
        response = currency_api_service.perform
        @last_updated_at = response['meta']['last_updated_at']
        response['data']
      end

      def currency_api_service
        @currency_api_service ||= CurrencyApi::ExchangeRates::GetService.new
      end

      def backup_records(records)
        return if records.empty?

        list_exchanges = []

        records.each do |record|
          current_datetime = DateTime.current
          list_exchanges << ForeignExchangesBuilder
            .build(record.merge!('last_updated_at' => last_updated_at))
            .merge!(created_at: current_datetime, updated_at: current_datetime)
        end

        ForeignExchange.upsert_all(list_exchanges, unique_by: :code) unless list_exchanges.empty?
      end
    end
  end
end
