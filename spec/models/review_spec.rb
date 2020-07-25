require 'rails_helper'

RSpec.describe Review, type: :model do
  let!(:review) { create(:review) }

  describe "relation" do
    it "roomを削除するとreviewも削除される" do
      expect do
        review.room.destroy
      end.to change(Review, :count).by(-1)
    end

    it "userを削除するとreviewも削除される" do
      expect do
        review.user.destroy
      end.to change(Review, :count).by(-1)
    end
  end

  describe "validation" do
    it "有効なファクトリを持つこと" do
      expect(review).to be_valid
    end

    it "room_idが無いと無効" do
      review.room_id = nil
      review.valid?
      expect(review.errors.full_messages).to include "会議室を入力してください"
    end

    it "user_idが無いと無効" do
      review.user_id = nil
      review.valid?
      expect(review.errors.full_messages).to include "利用者を入力してください"
    end

    it "評価が無いと無効" do
      review.rate = nil
      review.valid?
      expect(review.errors.full_messages).to include "評価を入力してください"
    end

    it "コメントが無いと無効" do
      review.comment = nil
      review.valid?
      expect(review.errors.full_messages).to include "コメントを入力してください"
    end
  end

  describe "enum" do
    context "rateが0〜4の時" do
      let(:enum) { { very_good: 0, good: 1, normal: 2, bad: 3, very_bad: 4 } }

      it "enumを返す" do
        enum.each do |key, value|
          review.rate = value
          expect(review.rate).to eq key.to_s
        end
      end
    end

    context "rateが0~4以外の時" do
      let(:invalid_enum) { [-1, 1.1, 5] }

      it "例外が発生する" do
        invalid_enum.each do |n|
          expect do
            review.rate = n
          end.to raise_error(ArgumentError)
        end
      end
    end
  end
end
