require 'bundler/setup'
Bundler.setup

require 'redikey'

RSpec.configure do |config|
  config.color = true
  config.tty = true
end
