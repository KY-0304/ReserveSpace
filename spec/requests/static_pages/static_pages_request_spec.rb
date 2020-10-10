RSpec.describe "StaticPages", type: :request do
  describe "GET #home" do
    it "ステータスコード200を返す" do
      get root_path
      expect(response.status).to eq 200
    end
  end

  describe "GET #search" do
    it "ステータスコード200を返す" do
      get search_path
      expect(response.status).to eq 200
    end
  end

  describe "GET #about" do
    it "ステータスコード200を返す" do
      get about_path
      expect(response.status).to eq 200
    end
  end
end
