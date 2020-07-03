require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "GET #home" do
    it "ステータスコード200を返す" do
      get root_path
      expect(response.status).to eq 200
    end
  end
end
