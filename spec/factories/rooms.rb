FactoryBot.define do
  factory :room do
    association :owner
    name { "テスト貸会議室" }
    description { "貸会議室の説明" }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'public/images/room.jpg')) }
    postcode { 1080073 }
    prefecture_code { 13 }
    address_city { "港区" }
    address_street { "三田1-1-1" }
    address_building { "テストビル1階" }
    phone_number { "03-1234-5678" }
    hourly_price { 2000 }
    business_start_time { "09:00:00" }
    business_end_time { "20:00:00" }
  end
end
