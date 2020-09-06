require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'simplecov'
SimpleCov.start
require 'capybara/rspec'
require 'factory_bot'

Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end
RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true

  # config.use_active_record = false

  # RSpec.describe UsersController, type: :controller do
  #   ...
  # end
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  # config.filter_gems_from_backtrace("gem name")

  # deviseのテストヘルパーを使用する
  config.include RequestSpecHelper, type: :request
  config.include Devise::Test::IntegrationHelpers, type: :system

  # テスト終了時にアップロードした画像を削除する
  config.after(:all) { FileUtils.rm_rf(Dir["#{Rails.root}/public/uploads_#{Rails.env}/"]) if Rails.env.test? }

  # デフォルトでaggregate_failuresを使用する
  config.define_derived_metadata do |meta|
    meta[:aggregate_failures] = true unless meta.key?(:aggregate_failures)
  end

  # ActiveSupportのヘルパーを使用する
  config.include ActiveSupport::Testing::TimeHelpers

  config.include PayjpMocks
end
