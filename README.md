NessusClient
=========

Usable, fast, simple Ruby gem for Tenable Nessus Pro v7.x and v8.x
NessusClient was designed to be simple, fast and performant through communication with Nessus over REST interface.

[![Gem Version](https://badge.fury.io/rb/nessus_client.svg)](https://badge.fury.io/rb/nessus_client) [![codecov](https://codecov.io/gh/heyder/nessus_client/branch/master/graph/badge.svg)](https://codecov.io/gh/heyder/nessus_client) [![Inline docs](http://inch-ci.org/github/heyder/nessus_client.svg?branch=master)](http://inch-ci.org/github/heyder/nessus_client)

**Ruby gem for Nessus API**

  * [Source Code](https://github.com/heyder/nessus_client)
  * [API documentation](https://rubydoc.info/github/heyder/nessus_client/master)
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

nc = NessusClient.new(
  {
    :uri=>'https://localhost:8834', 
    :username=>'user',
    :password=> 'password'
  }
)
scan_uuid = nc.launch_by_name('scan_name',['192.168.10.0/28'])

while true do
 scan_status = Oj.load( nc.scan_details( scan_uuid ) )["info"]["status"] 
  if scan_status == "done"
    export_id = nc.export_request( scan_uuid )
    while true do
      export_status = Oj.load( nc.export_status( export_id ) )["status"]
      if export_status == "ready"
        open("scan_report", "wb") do |file|
          file.write(nc.export_download( scan_uuid ))
        end
        break  
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
