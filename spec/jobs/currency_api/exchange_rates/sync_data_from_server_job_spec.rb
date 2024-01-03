# frozen_string_literal: true

require 'rails_helper'

describe CurrencyApi::ExchangeRates::SyncDataFromServerJob, type: :job do
  let(:file_path) { 'spec/fixtures/currency_api/exchange_rates/success_result_resume.json' }
  let(:file) { Rack::Test::UploadedFile.new(file_path, 'application/json') }

  describe '#perform' do
    context 'when the server returns data' do
      let(:file_path) { 'spec/fixtures/currency_api/exchange_rates/success_result_resume.json' }
      let(:file) { Rack::Test::UploadedFile.new(file_path, 'application/json') }

      before do
        allow_any_instance_of(CurrencyApi::ExchangeRates::GetService)
          .to receive(:perform).and_return(JSON.parse(file.read))
      end

      it 'should create the records' do
        expect { described_class.perform_now }.to change(ForeignExchange, :count).by(3)
      end
    end
  end
end
