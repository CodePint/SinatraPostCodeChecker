
require 'active_support'
require 'faraday'
require 'json'
require 'pry'

require_relative '../postcodes_checker/exceptions'
require_relative 'exceptions'

module PostcodesAPI
  class Client
    include PostcodesApiExceptions
    include PostcodesCheckerExceptions

    def initialize(base_uri=nil, timeout=3, retry_config={})
      @base_uri = base_uri || ENV["POSTCODES_API_BASE_URI"]
      @timeout = timeout
      @retry_config = retry_config
    end

    def lookup_postcode(postcode)
      begin
        postcode = CGI.escape(postcode.strip.chomp)
        request(verb: :get, endpoint: "postcodes/#{postcode}")
      rescue NotFoundError => e
        raise PostcodeNotFound if postcode_not_found?(e)
        raise PostcodeInvalid if postcode_invalid?(e)
        raise
      end
    end

    private

    def request(verb:, endpoint:, params: {})
      response = connection.send(verb, endpoint, params)
      parsed = JSON.parse(response.body)
      return parsed if response.success?

      raise HTTP_EXCEPTIONS[response.status].new(parsed["error"])
    end

    def postcode_not_found?(error)
      error.message.casecmp?("postcode not found")
    end

    def postcode_invalid?(error)
      error.message.casecmp?("invalid postcode")
    end

    def connection
      @conn ||= Faraday.new(@base_uri) do |c|
        c.request :retry, configure_retries.merge(@retry_config)
        c.options.timeout = @timeout
        c.request :url_encoded
        c.adapter :net_http
      end
    end

    def configure_retries
      config = {max: 3, interval: 0.5, backoff_factor: 0}
      config[:retry_statuses] = (500..599).to_a
      config[:methods] = [:get, :post]
      config[:exceptions] = FARADAY_EXCEPTIONS
      config
    end
  end
end