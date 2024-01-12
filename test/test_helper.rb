# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require 'simplecov'
SimpleCov.start "rails" do
  add_filter '/test/'
end

require_relative "../test/dummy/config/environment"
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../test/dummy/db/migrate", __dir__)]
ActiveRecord::Migrator.migrations_paths << File.expand_path("../db/migrate", __dir__)
require_relative "../test/support/sign_in_as_helper.rb"
require "rails/test_help"
require 'bcrypt'

# Load fixtures from the engine
if ActiveSupport::TestCase.respond_to?(:fixture_paths=)
  ActiveSupport::TestCase.fixture_paths = [File.expand_path("fixtures", __dir__)]
  ActionDispatch::IntegrationTest.fixture_paths = ActiveSupport::TestCase.fixture_paths
  ActiveSupport::TestCase.file_fixture_path = File.expand_path("fixtures", __dir__) + "/files"
  ActiveSupport::TestCase.fixtures :all
end

class ActionDispatch::IntegrationTest
  include SignInAsHelper
end
