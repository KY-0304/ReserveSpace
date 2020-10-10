RSpec.describe Favorite, type: :model do
  describe "validation" do
    let(:favorite)       { create(:favorite) }
    let(:other_favorite) { favorite.dup }

    it "有効なファクトリを持つこと" do
      expect(favorite).to be_valid
    end

    it "user_idが無いと無効" do
      favorite.user_id = nil
      favorite.valid?
      expect(favorite.errors.full_messages).to include "利用者を入力してください"
    end

    it "space_idが無いと無効" do
      favorite.space_id = nil
      favorite.valid?
      expect(favorite.errors.full_messages).to include "スペースを入力してください"
    end

    it "space_id, user_idの組み合わせが一意でないと無効" do
      other_favorite.valid?
      expect(other_favorite.errors.full_messages).to include "Userはすでに存在します"
    end
  end
end
