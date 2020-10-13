RSpec.describe "Users::Guests", type: :request do
  describe "POST#create" do
    before do
      post users_guests_path
    end

    it "root_pathにリダイレクトする" do
      expect(response).to redirect_to root_path
    end

    it "フラッシュを返す" do
      expect(flash[:notice]).to eq "ゲストユーザーとしてログインしました。"
    end
  end
end
