# == Schema Information
#
# Table name: reservations
#
#  id         :bigint           not null, primary key
#  end_time   :datetime         not null
#  start_time :datetime         not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  charge_id  :string
#  space_id   :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_reservations_on_space_id                 (space_id)
#  index_reservations_on_space_id_and_end_time    (space_id,end_time) UNIQUE
#  index_reservations_on_space_id_and_start_time  (space_id,start_time) UNIQUE
#  index_reservations_on_user_id                  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (space_id => spaces.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :reservation do
    association :space
    association :user
    start_time { Time.current }
    end_time   { Time.current + 1.hour }
    charge_id  { nil }
  end
end
