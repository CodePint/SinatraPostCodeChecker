require 'active_record'
require_relative 'exceptions'
require_relative '../postcodes_api/exceptions'
require_relative '../postcodes_api/client'
require_relative '../../models/LSOA'
require_relative '../../models/postcode'

module PostcodesChecker
  class Service
    include PostcodesCheckerExceptions

    def initialize(api_client)
      @api_client = api_client
    end

    def servicable?(postcode)
      Postcode.validate!(postcode)
      Postcode.allowed?(postcode) || LSOA.allowed?(get_lsoa(postcode))
    end

    def get_lsoa(postcode)
      begin
        @api_client.lookup_postcode(postcode)["result"]["lsoa"].downcase
      rescue PostcodeNotFound
        return false
      end
    end
  end
end

