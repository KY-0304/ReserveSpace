FactoryBot.define do
  factory :setting do
    association :space
    date_range_reservation_unacceptable { false }
    reservation_unacceptable_start_day {}
    reservation_unacceptable_end_day {}
  end
end
