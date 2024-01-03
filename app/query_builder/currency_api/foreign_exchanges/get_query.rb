# frozen_string_literal: true

module CurrencyApi
  module ForeignExchanges
    # Query builder class in charge to manage the logic for
    # search the ForeignExchange records with the specific args
    class GetQuery
      INTERNAL_SERVER_CODE = 500
      NOT_FOUND_CODE = 404
      SUCCESS_CODE = 200
      FORMAT_INVALID_MSG = 'Invalid format, the param should have the format YYYY-MM-DDThh:mm:ss'
      RECORDS_NOT_FOUND_MSG = 'Records not found'

      include CurrenciesHelper
      include ServiceBehavior

      attr_reader :currency, :finit, :fend, :result, :result_code

      validates :currency, presence: true
      validate :finit_in_valid_format
      validate :fend_in_valid_format

      def initialize(args = {})
        @currency = args['currency']
        @finit = args['finit']
        @fend = args['fend']
        @result_code = 200
      end

      def perform
        @result = ForeignExchange.none unless valid?
        @result = search_query if result.nil?
        define_status_code(result)
        result
      rescue StandardError => e
        errors.add(:base, e.message)
        define_status_code(INTERNAL_SERVER_CODE)
        ForeignExchange.none
      end

      private

      def evaluate_format_as_datetime(date_key, datetime_str)
        return nil if datetime_str.blank?
        return datetime_str.strftime(FORMAT_DATETIME_FOR_QUERY_SEARCH) if datetime_str.is_a?(DateTime)

        DateTime.strptime(datetime_str, FORMAT_DATETIME_FOR_QUERY_SEARCH)
      rescue ArgumentError
        errors.add(date_key, FORMAT_INVALID_MSG)
        nil
      end

      def search_query
        @search_query ||= ForeignExchange.where(search_args)
      end

      def search_args
        @search_args ||= begin
          query = []
          query << "code LIKE '#{currency}'" if currency != 'all'
          query << "last_updated_at >= '#{finit}'" unless finit.blank?
          query << "last_updated_at <= '#{fend}'" unless fend.blank?
          query.join(' AND ')
        end
      end

      def finit_in_valid_format
        evaluate_format_as_datetime(:finit, finit)
        errors.empty?
      end

      def fend_in_valid_format
        evaluate_format_as_datetime(:fend, fend)
        errors.empty?
      end

      def define_status_code(query_result, status_code = nil)
        unless status_code.nil?
          @result_code = status_code
          return
        end

        if query_result.empty? && valid?
          errors.add(:base, RECORDS_NOT_FOUND_MSG)
          return @result_code = NOT_FOUND_CODE
        end

        return @result_code = INTERNAL_SERVER_CODE unless valid?

        @result_code = SUCCESS_CODE
      end
    end
  end
end
