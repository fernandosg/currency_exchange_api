# frozen_string_literal: true

require 'rails_helper'

describe CurrencyApi::ForeignExchanges::GetQuery do
  include CurrenciesHelper

  let(:last_updated_at) { DateTime.current }
  let(:currency_exchange) do
    create(:foreign_exchange, last_updated_at:)
  end

  let(:finit) { nil }
  let(:fend) { nil }
  let(:currency) { currency_exchange.code }

  let(:args_for_service) do
    {
      'currency' => currency,
      'finit' => finit,
      'fend' => fend
    }
  end

  let(:subject) { described_class.new(args_for_service) }

  describe '#perform' do
    context 'when the args are valid' do
      context 'when is passed at least the currency' do
        it 'returns a collection that include the expecte foreign exchange with status 200' do
          expect(subject.perform).to include(currency_exchange)
          expect(subject.result_code).to be_eql(described_class::SUCCESS_CODE)
        end
      end

      context 'when is passed the finit arg' do
        context 'when doesnt have the expected format' do
          let(:finit) { '2024-01-2 23:02:00' }

          it 'returns an empty collection and have an error register' do
            expect(subject.perform).to be_empty
            expect(subject.errors.full_messages).to include("Finit #{described_class::FORMAT_INVALID_MSG}")
            expect(subject.result_code).to be_eql(described_class::INTERNAL_SERVER_CODE)
          end
        end

        context 'when it matches with a previous record' do
          let(:finit) do
            DateTime.current
              .strftime(CurrenciesHelper::FORMAT_DATETIME_FOR_QUERY_SEARCH)
          end

          it 'returns a collection that include the expecte foreign exchange' do
            expect(subject.perform).to include(currency_exchange)
          end
        end

        context 'when doesnt matches with a previous record' do
          let(:finit) do
            (DateTime.current + 1.day)
              .strftime(CurrenciesHelper::FORMAT_DATETIME_FOR_QUERY_SEARCH)
          end

          it 'returns an empty collection' do
            expect(subject.perform).to be_empty
            expect(subject.result_code).to be_eql(described_class::NOT_FOUND_CODE)
          end
        end
      end

      context 'when is passed the fend arg' do
        context 'when doesnt have the expected format' do
          let(:fend) { '2024-01-2 23:02:00' }

          it 'returns an empty collection and have an error register' do
            expect(subject.perform).to be_empty
            expect(subject.errors.full_messages).to include("Fend #{described_class::FORMAT_INVALID_MSG}")
            expect(subject.result_code).to be_eql(described_class::INTERNAL_SERVER_CODE)
          end
        end

        context 'when it matches with a previous record' do
          let(:fend) do
            (DateTime.current + 1.day)
              .strftime(CurrenciesHelper::FORMAT_DATETIME_FOR_QUERY_SEARCH)
          end

          it 'returns a collection that include the expecte foreign exchange' do
            expect(subject.perform).to include(currency_exchange)
          end
        end

        context 'when doesnt matches with a previous record' do
          let(:fend) { DateTime.current.strftime(CurrenciesHelper::FORMAT_DATETIME_FOR_QUERY_SEARCH) }

          it 'returns an empty collection' do
            expect(subject.perform).to be_empty
            expect(subject.result_code).to be_eql(described_class::NOT_FOUND_CODE)
          end
        end
      end
    end
  end
end
