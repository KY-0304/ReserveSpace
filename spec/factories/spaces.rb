# == Schema Information
#
# Table name: spaces
#
#  id                  :bigint           not null, primary key
#  address_building    :string
#  address_city        :string           not null
#  address_street      :string           not null
#  business_end_time   :time             not null
#  business_start_time :time             not null
#  capacity            :integer          not null
#  description         :text
#  hourly_price        :integer          not null
#  images              :jsonb
#  impressions_count   :integer          default(0)
#  latitude            :float
#  longitude           :float
#  name                :string           not null
#  phone_number        :string           not null
#  postcode            :integer          not null
#  prefecture_code     :integer          not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  owner_id            :bigint           not null
#
# Indexes
#
#  index_spaces_on_address_building     (address_building)
#  index_spaces_on_address_city         (address_city)
#  index_spaces_on_address_street       (address_street)
#  index_spaces_on_business_end_time    (business_end_time)
#  index_spaces_on_business_start_time  (business_start_time)
#  index_spaces_on_hourly_price         (hourly_price)
#  index_spaces_on_owner_id             (owner_id)
#  index_spaces_on_postcode             (postcode)
#  index_spaces_on_prefecture_code      (prefecture_code)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => owners.id)
#
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
