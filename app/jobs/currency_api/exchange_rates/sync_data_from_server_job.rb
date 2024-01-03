# frozen_string_literal: true

module CurrencyApi
  module ExchangeRates
    # Job in charge to fetch the data
    # from the CurrencyAPI service and be register
    # in the local db (toward the service class BackupProcess)
    class SyncDataFromServerJob < ApplicationJob
      def perform(*_args)
        execute_backup_process
      end

      private

      def execute_backup_process
        CurrencyApi::ExchangeRates::BackupProcess.new.perform
      end
    end
  end
end
