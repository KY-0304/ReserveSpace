require 'rails_helper'

RSpec.describe Favorite, type: :model do
  let(:favorite) { create(:favorite) }

  it "有効なファクトリを持つこと" do
    expect(favorite).to be_valid
  end

  it "user_idが無いと無効" do
    favorite.user_id = nil
    favorite.valid?
    expect(favorite.errors.full_messages).to include "ユーザーを入力してください"
  end

  it "room_idが無いと無効" do
    favorite.room_id = nil
    favorite.valid?
    expect(favorite.errors.full_messages).to include "会議室を入力してください"
  end

  it "room_id, user_idの組み合わせが一意でないと無効" do
    other_favorite = favorite.dup
    other_favorite.valid?
    expect(other_favorite.errors.full_messages).to include "Userはすでに存在します"
  end
end
