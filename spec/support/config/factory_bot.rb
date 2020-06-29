RSpec.configure do |config|
  # FactoryBotのメソッドを省略して使用できるようにする
  config.include FactoryBot::Syntax::Methods

  # springが原因でfactoryが正しく読み込まれないことを防ぐ
  config.before :all do
    FactoryBot.reload
  end
end
