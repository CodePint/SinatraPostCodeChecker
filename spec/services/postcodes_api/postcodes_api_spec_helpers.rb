# future updates could use faker or vcr gems to generate data
# alongside integration with proper factory helpers (factory bot)

module PostcodesApiSpecHelpers
  def success_response(result=true)
    {"status" => 200, "result" => result}
  end

  def error_response(status, error)
    {"status" => status, "error" => error}
  end

  def not_found_response(error="Resource not found")
    error_response(404, error)
  end

  def bad_request_response(error="No query submitted")
    error_response(400, error)
  end

  def internal_server_error_response(error="Internal server error")
    error_response(500, error)
  end

  def postcode_lookup_response(postcode, lsoa="mocked_lsoa", country="England")
    {
      "status" => 200,
      "result" => {
        "postcode" => postcode,
        "quality" => 1,
        "eastings" => 12345,
        "northings" => 12345,
        "country" => country,
        "nhs_ha" => "mocked nhs ha",
        "longitude" => "-00.0000",
        "latitude" => "00.0000",
        "european_electoral_region" => "na",
        "primary_care_trust" => lsoa,
        "region" => "mocked region",
        "lsoa" => "#{lsoa} 123A",
        "msoa" => "#{lsoa} 123",
        "incode" => "000",
        "outcode" => postcode.split(" ")[0],
        "parliamentary_constituency" => "mocked constituency",
        "admin_district" => lsoa,
        "parish" => "#{lsoa}, parished area",
        "admin_county" => nil,
        "admin_ward" => "mocked admin ward",
        "ced" => nil,
        "ccg" => "mocked ccg",
        "nuts" => "mocked nuts",
        "codes" => {
          "admin_district" => "00000000",
          "admin_county" => "00000000",
          "admin_ward" => "00000000",
          "parish" => "00000000",
          "parliamentary_constituency" => "00000000",
          "ccg" => "00000000",
          "ccg_id" => "00000000",
          "ced" => "00000000",
          "nuts" => "00000000",
          "lsoa" => "00000000",
          "msoa" => "00000000",
          "lau2" => "00000000",
        }
      }
    }
  end
end

