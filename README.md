NessusClient
=========

Usable, fast, simple Ruby gem for Tenable Nessus Pro from v7.0.1 to  v8.3.1
NessusClient was designed to be simple, fast and performant through communication with Nessus over REST interface.

[![Gem Version](https://badge.fury.io/rb/nessus_client.svg)](https://badge.fury.io/rb/nessus_client)
[![Maintainability](https://api.codeclimate.com/v1/badges/9cca9e4260cadd8ab98d/maintainability)](https://codeclimate.com/github/heyder/nessus_client/maintainability)
[![codecov](https://codecov.io/gh/heyder/nessus_client/branch/master/graph/badge.svg)](https://codecov.io/gh/heyder/nessus_client)
[![Inline docs](http://inch-ci.org/github/heyder/nessus_client.svg?branch=master)](http://inch-ci.org/github/heyder/nessus_client)

**Ruby gem for Nessus API**

  * [Source Code](https://github.com/heyder/nessus_client)
  * [API documentation](https://rubydoc.info/github/heyder/nessus_client)
  * [Rubygem](https://rubygems.org/gems/nessus_client)


## Contact

*Code and Bug Reports*

* [Issue Tracker](https://github.com/heyder/nessus_client/issues)
* See [CONTRIBUTING](https://github.com/heyder/nessus_client/blob/master/CONTRIBUTING.md) for how to contribute along
with some common problems to check out before creating an issue.


Getting started
---------------

```ruby
require 'nessus_client'

nc = NessusClient.new( { :uri=>'https://localhost:8834', :username=>'username',:password=> 'password'} )
status = nc.server_status 
puts status
puts nc.server_properties

if status['status'] == 'ready'
  scan_id = nc.get_scan_by_name('Monthly Scan')
  scan_uuid = nc.launch_by_name( 'Monthly Scan', ['127.0.0.1'])['scan_uuid']

  loop do
   puts `clear`
   scan_status = nc.scan_details( scan_id )["info"]["status"] 
   puts " #{scan_id} - #{scan_uuid} - #{scan_status} "
   sleep 5
   if ["completed","canceled"].include? scan_status
      export_request = nc.export_request(scan_id, "nessus" )
      puts " export request: #{export_request}"
      while true do
        puts `clear`
        export_status =  nc.token_status( export_request['token'])["status"]
        puts " export status: #{export_status}"
        sleep 5
        if export_status == "ready"
          puts " downloading..."
          open("scan_report", "wb") do |file|
            file.write(nc.token_download( export_request['token'] ))
          end
          exit 0
        end
      end
   end
  end
end
```

## Installation

Add this line to your application's Gemfile:

    gem 'nessus_client'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nessus_client

## Requirements

Requirements are Exon for HTTP(S) and Oj parsing:

```ruby
require 'excon'
require 'oj'
```

## Code of Conduct

Everyone participating in this project's development, issue trackers and other channels is expected to follow our
[Code of Conduct](./CODE_OF_CONDUCT.md).

## Contributing

See the [contributing guide](./CONTRIBUTING.md).

## Copyright

Copyright (c) 2016-2019 Heyder Andrade. See MIT-LICENSE for details.
