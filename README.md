# SinatraPostCodeChecker
## A simple web application to work out if a given postcode is within a service area

### Installation
---
- Requires SQLite and Ruby 2.7.2
- Install dependancies with: `bundle install`

### Database
---
- Configure and seed the SQLite database: `rake db:setup`
- Production seed files should be placed at: `seeds/production`

### Running the project
---
- Run the server: `Bundle & Rackup`
- View the landing page at: `127.0.0.1:9292/postcodes`

### Tests
---
- Run the tests suite: `rspec`