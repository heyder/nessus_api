require_relative 'lib/nessus_client/version'
Gem::Specification.new do |spec|
  spec.name           = %q{nessus_client}
  spec.author         = %q{Heyder}
  spec.version        = NessusClient::VERSION
  spec.date           = %q{2018-11-28}
  spec.summary        = %q{Ruby wrapper for Nessus API}
  spec.licenses       = ['MIT']  
  spec.description    = "Ruby wrapper for Nessus API (all verions)"
  spec.email          = 'eu@heyderandrade.org'
  spec.homepage       = 'https://rubygemspec.org/gems/nessus_client'
  spec.metadata       = { "source_code_uri" => "https://github.com/heyder/nessus_client" }
  spec.extra_rdoc_files = ['README.md', 'CONTRIBUTING.md']
  spec.files          = Dir['lib/**/*.rb']
  spec.require_paths  = ["lib"]
  spec.required_ruby_version = '>= 2.5.1'
  spec.add_runtime_dependency( 'excon', '~> 0.62' )
  spec.add_runtime_dependency( 'oj', '~> 3.7' )
  spec.add_runtime_dependency( 'json', '~> 2.1' )
  spec.add_development_dependency( 'rspec', '~> 3.2' )
  spec.add_development_dependency( 'bundler', '~> 1.12' )
  spec.add_development_dependency( 'pry', '~> 0.12.2' )
  spec.add_development_dependency( 'simplecov', '~> 0.17.0' )
  spec.add_development_dependency( 'codecov', '~> 0.1.14' )
  
  
end