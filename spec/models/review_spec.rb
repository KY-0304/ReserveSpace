require 'rails_helper'

RSpec.describe Review, type: :model do
  let(:review) { create(:review) }

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

  it "レートが無いと無効" do
    review.rate = nil
    review.valid?
    expect(review.errors.full_messages).to include "レートを入力してください"
  end

  it "レートが5.0より上だと無効" do
    review.rate = 5.1
    review.valid?
    expect(review.errors.full_messages).to include "レートは5以下の値にしてください"
  end

  it "レートが0だと無効" do
    review.rate = 0
    review.valid?
    expect(review.errors.full_messages).to include "レートは0より大きい値にしてください"
  end

  it "コメントが101文字以上だと無効" do
    review.comment = "a" * 101
    review.valid?
    expect(review.errors.full_messages).to include "コメントは100文字以内で入力してください"
  end
end
