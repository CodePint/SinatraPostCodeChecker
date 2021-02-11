require 'json'
require_relative '../config/environment'


def load_seed_data
  seed_path = ENV["SEED_PATH"] || "db/seeds/#{ENV['RACK_ENV']}"
  {
    postcodes: JSON.parse(File.read(File.join(seed_path, "postcodes.json"))),
    LSOAs:     JSON.parse(File.read(File.join(seed_path, "LSOAs.json")))
  }
end

def seed!
  seed_data = load_seed_data

  seed_data[:postcodes].each do |s|
    Postcode.create(s)
  end
  seed_data[:LSOAs].each do |s|
    LSOA.create(s)
  end
end

seed!
