RSpec.configure do |config|
  # システムスペックでjs: trueの時だけchoromeを起動する
 config.before(:each, type: :system) do
  driven_by :rack_test
 end

 config.before(:each, type: :system, js: true) do
  driven_by :selenium_chrome_headless
 end
end
