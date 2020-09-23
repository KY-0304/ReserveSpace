FactoryBot.define do
  factory :reservation do
    association :space
    association :user
    start_time { Time.current }
    end_time   { Time.current + 1.hour }
    charge_id  { nil }
  end
end
