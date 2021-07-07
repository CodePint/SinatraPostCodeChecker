require 'active_record'
require_relative 'exceptions'
require_relative '../postcodes_api/exceptions'
require_relative '../postcodes_api/client'
require_relative '../../models/LSOA'
require_relative '../../models/postcode'


module PostcodesChecker
  class Service
    include PostcodesCheckerExceptions

    def initialize(primary_client=nil, backup_client=nil)
      @primary_client = primary_client || PostcodesAPI::Client.new(ENV["POSTCODES_API_PRIMARY_URI"])
      @backup_client = backup_client || PostcodesAPI::Client.new(ENV["POSTCODES_API_BACKUP_URI"])
    end

    def servicable?(postcode)
      Postcode.validate!(postcode)
      return true if Postcode.allowed?(postcode)
      return true if LSOA.allowed?(get_lsoa(postcode))

      false
    end

    def get_lsoa(postcode)
      parse_lsoa(@primary_client.lookup_postcode(postcode), @primary_client)
    rescue StandardError => e
      postcode_error = e.instance_of?(PostcodeNotFound) || e.instance_of?(PostcodeInvalid)
      postcode_error ? raise : parse_lsoa(@backup_client.lookup_postcode(postcode), @backup_client)
    end

    def parse_lsoa(data, client)
      if client.base_uri.include? "http://postcodes.io"
        data["result"]["lsoa"]&.upcase
      elsif client.base_uri.include? "http://postcodes.r.us"
        data = data["results"]&.first
        data["district"]&.upcase
      end
    end
  end
end
