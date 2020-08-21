FactoryBot.define do
  factory :setting do
    association :space
    reservation_unacceptable { false }
    reservation_unacceptable_start_date {}
    reservation_unacceptable_end_date {}
  end
end
