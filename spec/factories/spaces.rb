FactoryBot.define do
  factory :space do
    association :owner
    name                { "スペース" }
    description         { "スペース説明" }
    images              { [Rack::Test::UploadedFile.new(File.join(Rails.root, 'public/images/space.jpg'))] }
    postcode            { 1080073 }
    prefecture_code     { 13 }
    address_city        { "港区" }
    address_street      { "三田1-1-1" }
    address_building    { "ReserveSpaceビル1階" }
    phone_number        { "03-#{rand(1000..9999)}-#{rand(1000..9999)}" }
    hourly_price        { rand(1..200) * 100 }
    capacity            { rand(1..10) * 10 }
    business_start_time { "09:00:00" }
    business_end_time   { "21:00:00" }

    trait :skip_create_setting do
      before(:create) { Space.skip_callback(:create, :after, :setting_create) }

      after(:create) { Space.set_callback(:create, :after, :setting_create) }
    end
  end
end
