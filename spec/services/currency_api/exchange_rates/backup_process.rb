require 'rails_helper'

describe CurrencyApi::ExchangeRates::BackupProcess do
  let(:file_path) { 'spec/fixtures/currency_api/exchange_rates/success_result_resume.json' }
  let(:file) { Rack::Test::UploadedFile.new(file_path, 'application/json') }
  let(:args_for_service) { {} }
  let(:subject) { described_class.new(args_for_service) }

  describe '#perform' do
    context 'when the service call return records' do
      before do
        allow_any_instance_of(CurrencyApi::ExchangeRates::GetService).to receive(:perform).and_return(JSON.parse(file.read))
      end

      it 'should create the expeccted records' do
        expect { subject.perform }.to change(ForeignExchange, :count).by(3)
      end
    end
  end
end