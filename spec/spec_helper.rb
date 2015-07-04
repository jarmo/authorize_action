require "simplecov"
require "coveralls"

SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start 

require File.expand_path("../lib/authorize_action", __dir__)

RSpec.configure do |config|
  config.order = :random
  config.color = true
end
