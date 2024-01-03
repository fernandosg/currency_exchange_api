desc "Sync data from Currency API"
task sync_from_server: :environment do
  CurrencyApi::ExchangeRates::SyncDataFromServerJob.perform_later
end