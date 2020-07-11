require 'rails_helper'

RSpec.describe "Reservations", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/reservations/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/reservations/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/reservations/new"
      expect(response).to have_http_status(:success)
    end
  end

end
