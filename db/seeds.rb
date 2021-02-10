require_relative '../config/environment'

seeds = {
  postcodes: [
    {value: "SH241AA", allowed: true},
    {value: "SH241AB", allowed: true},
    {value: "XXXXXX", allowed: false}
  ],
  LSOAs: [
    {value: "Southwark", allowed: true},
    {value: "Lambeth", allowed: true},
    {value: "Dummy", allowed: false}
  ]
}

seeds[:postcodes].each do |p|
  Postcode.create(p)
end

seeds[:LSOAs].each do |l|
  LSOA.create(l)
end
