# frozen_string_literal: true

require "mysql2-nested_hash_bind"
require "mysql2-cs-bind"
require "dotenv/load"
require "rspec/its"

Dir["#{__dir__}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include_context :database, database: true

  config.before(:suite) do
    down_migrate
    up_migrate
  end

  config.after(:suite) do
    down_migrate
  end
end
