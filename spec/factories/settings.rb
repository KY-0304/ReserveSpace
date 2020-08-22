FactoryBot.define do
  factory :setting do
    association :space, :skip_create_setting
    reservation_unacceptable { false }
    reservation_unacceptable_start_date { nil }
    reservation_unacceptable_end_date { nil }
  end
end
