require_relative 'boot'

require 'rails/all'
require 'csv'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ReserveSpace
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    # タイムゾーンを東京に設定
    config.time_zone = 'Tokyo'
    # デフォルトの言語を日本語に設定
    config.i18n.default_locale = :ja
    # ジェネレーターの設定
    config.generators do |g|
      g.test_framework :rspec,
                       fixtures: true,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false,
                       controller_specs: false,
                       request_specs: true,
                       system_specs: true
      g.fixture_replacement :factory_bot, dir: "spec/factories"
      g.system_tests false
      g.stylesheets false
      g.javascripts false
      g.helper false
    end
    # utils/apiを読み込む設定
    config.paths.add "#{Rails.root}/app/utils/api", eager_load: true

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
