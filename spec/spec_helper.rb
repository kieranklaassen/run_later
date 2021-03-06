require 'bundler/setup'
Bundler.require :default, :development

require 'laters'

Combustion.initialize! :active_record, :active_job
require 'rspec/rails'

ActiveJob::Base.queue_adapter = :test

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
