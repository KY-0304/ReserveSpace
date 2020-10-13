RSpec.describe "OwnersGuests", type: :request do
  describe "POST#create" do
    before do
      post owners_guests_path
    end

    it "spaces_pathにリダイレクトする" do
      expect(response).to redirect_to spaces_path
    end

    it "フラッシュを返す" do
      expect(flash[:notice]).to eq "ゲストオーナーとしてログインしました。"
    end
  end
end
