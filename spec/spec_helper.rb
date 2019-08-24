require 'simplecov'
require 'oj'
require 'pry'
require 'excon'
require 'regexp-examples'
SimpleCov.start

# require 'codecov'
# SimpleCov.formatter = SimpleCov::Formatter::Codecov

Dir[File.join(__dir__, '../lib', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, '../modules', '*.rb')].each { |file| require file }