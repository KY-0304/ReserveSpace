RSpec.configure do |config|
  config.before(:each) do
    Geocoder.configure(lookup: :test)
    Geocoder::Lookup::Test.set_default_stub([{ 'coordinates' => [35.6526489, 139.7443625] }])
  end
end
