module CurrencyApi
  class BaseService
    BASE_URL = 'https://api.currencyapi.com/v3/'.freeze

    attr_reader :args, :result

    def initialize(args = {})
      @args = args
    end

    def get_request
      @result = HTTParty.get(BASE_URL + resource_url, query: args_for_service)
    end

    private

    def apikey
      @apikey ||= ENV['API_KEY'] || 'cur_live_PNfciB6gzJaSODjelEMTVeefK9XE4AXT630EdgwA'
    end

    def args_for_service
      @args_for_service ||= args.merge!(apikey: apikey)
    end

    def resource_url
      raise StandardError, 'Should include this method to define a resource url'
    end
  end
end