FactoryBot.define do
  factory :setting do
    association :space
    unacceptable { false }
    unacceptable_start_time {}
    unacceptable_end_time {}
  end
end
