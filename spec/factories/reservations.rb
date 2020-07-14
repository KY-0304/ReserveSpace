FactoryBot.define do
  factory :reservation do
    association :room
    association :user
    start_time { Time.current }
    end_time { Time.current.since(6.hours) }
  end
end
