# frozen_string_literal: true

require "csvbuilder/dynamic/columns/core"

require "#{Dir.pwd}/spec/support/shared_context/with_context.rb"

Dir["#{Dir.pwd}/spec/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include WithThisThenContext
end
