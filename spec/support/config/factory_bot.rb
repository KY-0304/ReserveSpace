RSpec.configure do |config|
  # FactoryBotのメソッドを省略して使用できるようにする
  config.include FactoryBot::Syntax::Methods
end
