# frozen_string_literal: true

require 'rails_helper'

describe CurrencyApi::ExchangeRates::GetService do
  vcr_cassettes = {
    success: 'currency_api/exchange_rates/get_service/success',
    token_undefined: 'currency_api/exchange_rates/get_service/failure'
  }

  let(:args_for_service) { {} }
  let(:subject) { described_class.new(args_for_service) }

  describe '#perform' do
    context 'when the api key is defined' do
      before do
        allow(subject).to receive(:apikey).and_return('API_KEY_MOCK')
      end

      context 'when is not passed any argument' do
        it 'should return the expected data' do
          VCR.use_cassette(vcr_cassettes[:success]) do
            expect { subject.perform }.to change(CurrencyApiCallsLog, :count).by(1)
            expect(subject.result.keys).to be_eql(%w[meta data])
            expect(subject.result['data']).not_to be_empty
            expect(CurrencyApiCallsLog.last.failed_at).to be_nil
          end
        end

        context 'when is raise an Timeout::Error exception' do
          before do
            expect(subject).to receive(:execute_call).and_raise(Timeout::Error)
          end

          it 'should return an empty record' do
            VCR.use_cassette(vcr_cassettes[:success]) do
              expect { subject.perform }.to change(CurrencyApiCallsLog, :count).by(1)
              expect(CurrencyApiCallsLog.last.failed_at).not_to be_nil
            end
          end
        end

        context 'when is raise an Net::ReadTimeout exception' do
          before do
            expect(subject).to receive(:execute_call).and_raise(Net::ReadTimeout)
          end

          it 'should return an empty record' do
            VCR.use_cassette(vcr_cassettes[:success]) do
              expect { subject.perform }.to change(CurrencyApiCallsLog, :count).by(1)
              expect(CurrencyApiCallsLog.last.failed_at).not_to be_nil
            end
          end
        end
      end
    end

    context 'when the api key is not defined' do
      it 'returns an empty hash' do
        VCR.use_cassette(vcr_cassettes[:token_undefined]) do
          expect { subject.perform }.to change(CurrencyApiCallsLog, :count).by(1)
          expect(CurrencyApiCallsLog.last.failed_at).not_to be_nil
        end
      end
    end
  end
end
