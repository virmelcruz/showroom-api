require 'rails_helper'
require 'factory_bot'

RSpec.describe "User API", type: :request do
  headers = {
    "ACCEPT": "application/json"
  }
  
  describe "POST /users.json - creates user" do
    context "when request is valid" do
      before_count = User.count
      let(:valid_attributes) { { user: { name: "vipogi", email: "vipogi@yopmail.com", password: "1234qwer" } } }
      before { post "/users", params: valid_attributes , headers: headers }

      it { expect(response.content_type).to eq("application/json") }
      it { expect(JSON.parse(response.body)["name"]).to match("vipogi") }
      it { expect(response).to have_http_status(:created) }
      it { expect(User.count).not_to eq(before_count) }
    end

    context "when params is empty" do
      let(:invalid_attributes) { { user: { } } }
      before { post "/users", params: invalid_attributes, headers: headers }
      it { expect(response).to have_http_status(:bad_request) }
    end
  end
end