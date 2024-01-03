# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::CurrenciesController, type: :controller do
  render_views
  include CurrenciesHelper

  let(:last_updated_at) { DateTime.current }
  let(:query_class) { CurrencyApi::ForeignExchanges::GetQuery }
  let!(:currency_exchange) { create(:foreign_exchange, last_updated_at:) }
  let!(:extra_currency) { create(:foreign_exchange, code: 'BNP') }

  let(:finit) { nil }
  let(:fend) { nil }
  let(:currency) { currency_exchange.code }

  let(:params) do
    {
      currency:,
      finit:,
      fend:,
      format: :json
    }
  end

  describe 'GET #index' do
    let!(:execute) { get(:index, params:) }

    context 'when the args are valid' do
      let(:currency_as_hash) { convert_currency_mock_to_hash(currency_exchange) }

      it 'should return the expected record' do
        currencies = JSON.parse(response.body)['result']
        expect(response.status).to be_eql(200)
        expect(currencies.length).to be_eql(1)
        expect(currencies).to include(currency_as_hash)
      end

      context 'when the currency arg is defined with value "all"' do
        let(:currency) { 'all' }

        it 'should include all the currencies' do
          currencies = JSON.parse(response.body)['result']
          expect(response.status).to be_eql(200)
          expect(currencies.length).to be_eql(2)
          expect(currencies).to include(currency_as_hash)
          expect(currencies).to include(convert_currency_mock_to_hash(extra_currency))
        end
      end
    end

    context 'when is passed the finit' do
      context 'when have an invalid format' do
        let(:finit) { '2024-01-01 12:00:00' }

        it 'returns the expected message with the status code related' do
          expect(JSON.parse(response.body)['message'])
            .to include(query_class::FORMAT_INVALID_MSG)
          expect(response.status).to be_eql(query_class::INTERNAL_SERVER_CODE)
        end
      end
    end

    context 'when is passed the fend' do
      context 'when have an invalid format' do
        let(:fend) { '2024-01-01 12:00:00' }

        it 'returns the expected message with the status code related' do
          expect(JSON.parse(response.body)['message'])
            .to include(query_class::FORMAT_INVALID_MSG)
          expect(response.status).to be_eql(query_class::INTERNAL_SERVER_CODE)
        end
      end
    end

    context 'when the currency code is not found' do
      let(:currency) { 'TEST' }

      it 'returns the expected message with the status code related' do
        expect(JSON.parse(response.body)['message'])
          .to include(query_class::RECORDS_NOT_FOUND_MSG)
        expect(response.status).to be_eql(query_class::NOT_FOUND_CODE)
      end
    end
  end

  private

  def convert_currency_mock_to_hash(currency_mock)
    hash_info = currency_mock.attributes.except('id', 'created_at', 'updated_at')
    hash_info['last_updated_at'] = format_last_updated_at(hash_info['last_updated_at'])
    hash_info
  end
end
