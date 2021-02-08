Dir.glob(File.expand_path("../../app/models/*.rb", __FILE__)).each {|f| require_relative f }

seeds = {
  postcodes: [
    {value: "SH241AA", allowed: true},
    {value: "SH241AB", allowed: true}
  ],
  LSOAs: [
    {value: "Southwark", allowed: true},
    {value: "Lambeth", allowed: true}
  ]
}

seeds[:postcodes].each do |p|
  Postcode.create(p)
end

seeds[:LSOAs].each do |l|
  Postcode.create(l)
end