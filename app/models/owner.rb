# == Schema Information
#
# Table name: owners
#
#  id                     :bigint           not null, primary key
#  company_name           :string           not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_owners_on_company_name          (company_name) UNIQUE
#  index_owners_on_email                 (email) UNIQUE
#  index_owners_on_reset_password_token  (reset_password_token) UNIQUE
#
class Owner < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  after_destroy :check_all_space_destroyed

  has_many :spaces, dependent: :destroy

  validates :company_name, length: { maximum: MAX_COMPANY_NAME_LENGTH }, presence: true, uniqueness: true
  validates :email,        length: { maximum: MAX_EMAIL_LENGTH }
  validates :agreement, acceptance: true

  def self.guest
    find_or_create_by!(email: "guest@example.com") do |owner|
      owner.company_name = "ReserveSpace株式会社"
      owner.password     = "password"
    end
  end

  private

  def check_all_space_destroyed
    throw(:abort) unless spaces.empty?
  end
end
