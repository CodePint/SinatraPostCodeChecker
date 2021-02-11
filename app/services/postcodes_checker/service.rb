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
      return true if Postcode.allowed?(postcode)
      return true if LSOA.allowed?(get_lsoa(postcode))

      false
    end

    def get_lsoa(postcode)
      @api_client.lookup_postcode(postcode)["result"]["lsoa"]&.upcase
    end
  end
end
