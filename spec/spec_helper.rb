# frozen_string_literal: true

require 'oj'
require 'pry'
require 'excon'
require 'regexp-examples'
require 'simplecov'
require 'nokogiri'
SimpleCov.start
require 'codecov'
SimpleCov.formatter = SimpleCov::Formatter::Codecov

Dir[File.join(__dir__, '../lib', '*.rb')].sort_by.each do |file|
  require file
end
Dir[File.join(__dir__, '../modules', '*.rb')].sort_by.sort_by.each do |file|
  require file
end
