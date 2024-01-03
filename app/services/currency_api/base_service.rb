# frozen_string_literal: true

module CurrencyApi
  # Base service class for all the service that should
  # be communicate to the CurrencyAPI
  class BaseService
    BASE_URL = 'https://api.currencyapi.com/v3/'

    attr_reader :args, :result

    def initialize(args = {})
      @args = args
    end

    def request_get
      perform_action do
        HTTParty.get(BASE_URL + resource_url, query: args_for_service)
      end
    end

    def perform_action(&block)
      log_call
      Timeout.timeout(limit_timeout_seconds) do
        @result = execute_call(&block)
      end

      raise StandardError, result['message'] if result.keys.length == 1

      finish_call
    rescue Timeout::Error, Net::ReadTimeout
      mark_as_failed_call
    rescue StandardError
      mark_as_failed_call
    end

    private

    def log_call
      @log_call ||= CurrencyApiCallsLog.create(started_at: DateTime.current)
    end

    def finish_call
      @log_call.update_column(:finished_at, DateTime.current)
      result
    end

    def mark_as_failed_call
      @log_call.update_column(:failed_at, DateTime.current)
      @result = {}
    end

    def apikey
      @apikey ||= ENV['CURRENCY_API_SERVICE_KEY']
    end

    def limit_timeout_seconds
      @limit_timeout_seconds ||= ENV['LIMIT_TIMEOUT_CURRENCY_API_SERVICE']&.to_i || 90
    end

    def args_for_service
      @args_for_service ||= args.merge!(apikey:)
    end

    def resource_url
      raise StandardError, 'Should include this method to define a resource url'
    end

    def execute_call
      yield
    end
  end
end
