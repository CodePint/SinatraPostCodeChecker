# SinatraPostCodeChecker
## A simple web application to work out if a given postcode is within a service area
---
- Postcodes are grouped into larger blocks called LSOAs, a postcodes LSOA can be found via the **[postcodes.io](https://postcodes.io/ "postcodes.io api homepage")** API. This can be leveraged using a `PostcodesAPI::Client` wrapper class instance and invoking the `lookup_postcode` method.

- Configured LSOAs are stored in the local database, only postcodes with a matching LSOA whos `allowed` column is set to `true` are servicable. This can be checked by invoking the `LSOA.allowed?` model method.

- Some postcodes are unknown by the API or may be servicable despite being outside of the
allowed LSOAs. These are stored in the database and are servicable if their `allowed` column is set to `true`. This can be checked by invoking the `Postcode.allowed?` model method.

- Any postcode not in the LSOA allowed list or the Postcode allowed list is not servicable, this can be checked by leveraging the `PostcodesChecker::Service` class instance and invoking the `servicable?` method. This is core functionality is exposed publically via the `PostcodesController` using a html form at '`GET /postcodes`' to submit a request to '`GET /postcodes/check`' with a `postcode` param

### Using the application
---
- Navigate to `/postcodes` and enter the postcode you wish to check
- If a postcode is **servicable** it will render a message and a: *'✓'*
- If a postcode is **not servicable** it will render a message and a: *'✗'*
- If the postcode is **invalid**  it will render: *'Error: Invalid postcode:'*
- If a **server error** occurs or the request cannot be proccessed it will render: *'Error: Internal server error'*

### Installation
---
- Requires SQLite, Ruby 2.7.2 and Bundler gem
- Install dependancies with: `bundle install`

### Database
---
- Configure and seed the SQLite database: `rake db:setup`
- Seed files should be placed at: `seeds/#{RACK_ENV}/#{model}s.json`

### Running the project
---
- Run the server: `bundle & rackup`
- Navigate to `127.0.0.1:9292/postcodes`

### Tests
---
- Run the tests suite: `rspec`
---
### Future development
- If or when the Postcode/LSOA allowed list grows alongside additional data, we may want to transition to Postgres. SQLite is currently used due to its simplicity and the small amounts of data stored (Using json files with a simple whitelist array is also a valid approach to use for small amounts of data).
- The PostcodesController `/postcodes/check` function could become an API endpoint. For example `/postcodes/api/check` for use with external services or frontends, whilst preserving the original sinatra render functionality.
- The sinatra application and the postcodes.io remote api could both be run as docker services on the same server. This would improve ease of deployment, reduce latency and remove the reliance on a third party service.
- A redis db could be used to cache api calls to `postcodes.io`. This would speed up responses and reduce the number of external api calls.
