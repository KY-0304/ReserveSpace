# == Schema Information
#
# Table name: settings
#
#  id                                  :bigint           not null, primary key
#  accepted_until_day                  :integer
#  reject_same_day_reservation         :boolean          default(FALSE), not null
#  reservation_unacceptable            :boolean          default(FALSE), not null
#  reservation_unacceptable_end_date   :date
#  reservation_unacceptable_start_date :date
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#  space_id                            :bigint           not null
#
# Indexes
#
#  index_settings_on_space_id  (space_id)
#
# Foreign Keys
#
#  fk_rails_...  (space_id => spaces.id)
#
FactoryBot.define do
  factory :setting do
    association :space, :skip_create_setting
    reservation_unacceptable            { false }
    reservation_unacceptable_start_date { nil }
    reservation_unacceptable_end_date   { nil }
    reject_same_day_reservation         { false }
    accepted_until_day                  { nil }
  end
end
