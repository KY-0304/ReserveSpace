RSpec.describe Review, type: :model do
  describe "validation" do
    let(:used_space)        { create(:space) }
    let(:did_not_use_space) { create(:space) }
    let(:user)              { create(:user) }
    let!(:reservation)      { create(:reservation, :skip_validate, space: used_space, user: user, end_time: Time.current - 1.hour) }
    let(:review)            { build(:review, space: used_space, user: user) }

    it "有効なファクトリを持つこと" do
      expect(review).to be_valid
    end

    it "space_idが無いと無効" do
      review.space_id = nil
      review.valid?
      expect(review.errors.full_messages).to include "スペースを入力してください"
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

    it "コメントが1001文字以上だと無効" do
      review.comment = "a" * 1001
      review.valid?
      expect(review.errors.full_messages).to include "コメントは1000文字以内で入力してください"
    end

    it "利用したことのないスペースのレビュー投稿は無効" do
      review.space_id = did_not_use_space.id
      review.valid?
      expect(review.errors.full_messages).to include "利用したことの無いスペースにレビューを投稿することはできません。"
    end
  end

  describe "enum" do
    let(:review) { build(:review) }

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
