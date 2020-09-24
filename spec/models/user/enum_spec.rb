require 'rails_helper'

RSpec.describe User, type: :model do
  describe "enum" do
    let(:user) { create(:user) }

    context "genderが0〜2の時" do
      let(:enum) { { unanswered: 0, female: 1, male: 2 } }

      it "enumを返す" do
        enum.each do |key, value|
          user.gender = value
          expect(user.gender).to eq key.to_s
        end
      end
    end

    context "genderが0~2以外の時" do
      let(:invalid_enum) { [-1, 1.1, 3] }

      it "例外が発生する" do
        invalid_enum.each do |n|
          expect do
            user.gender = n
          end.to raise_error(ArgumentError)
        end
      end
    end
  end
end
