# frozen_string_literal: true

module Api
  module V1
    # API controller class to handle the search for the currencies expected
    class CurrenciesController < ApplicationController
      def index
        @query = CurrencyApi::ForeignExchanges::GetQuery.new(search_params)
        @query.perform
        respond_to do |format|
          format.json { render :index, status: @query.result_code }
        end
      end

      private

      def search_params
        params.permit(:currency, :finit, :fend)
      end
    end
  end
end
