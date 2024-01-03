require 'rails_helper'

describe CurrencyApi::ExchangeRates::GetService do
  vcr_cassettes = {
    success: 'currency_api/exchange_rates/get_service/success',
    failure: 'currency_api/exchange_rates/get_service/failure'
  }

  let(:args_for_service) { {} }
  let(:subject) { described_class.new(args_for_service ) }

  describe '#perform' do
    context 'when is not passed any argument' do
      it 'should return the expected data' do
        VCR.use_cassette(vcr_cassettes[:success]) do
          subject.perform
          expect(subject.result.keys).to be_eql(["meta", "data"])
          expect(subject.result['data']).not_to be_empty
        end
      end
    end
  end
end