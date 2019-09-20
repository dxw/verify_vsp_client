require "bundler/setup"
require "verify_vsp_client"
require "rack/test"
require "webmock/rspec"

require_relative "helpers"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  VerifyVspClient.configure do |config|
    config.vsp_host = "http://localhost:4567"
  end
end
