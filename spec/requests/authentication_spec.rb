require 'rails_helper'

RSpec.describe "Authentication API", type: :request do

  describe "POST /authentication - logins a user" do
    let!(:user) { create :user }
    let!(:headers) { valid_headers.except('Authorization') }
    let!(:valid_credentials) { { user: { email: user.email, password: user.password } } }
    let!(:invalid_credentials) { { user: { email: FFaker::Internet.safe_email, password: 'foo' } } }
      
    context "when request is valid" do
      before { post "/authentication", params: valid_credentials, headers: headers }
      
      it { expect(response.content_type).to eq("application/json") }
      it { expect(JSON.parse(response.body)).to be_an_instance_of(Hash) }
      it { expect(JSON.parse(response.body)).to have_key("token") }
      it { expect(response).to have_http_status(:ok) }
    end

    context "when params is invalid" do
      before { post "/authentication", params: invalid_credentials, headers: headers }

      it { expect(JSON.parse(response.body)).to have_key("error") }
      it { expect(JSON.parse(response.body)["error"]["status"]).to match("invalid credentials") }
      it { expect(response).to have_http_status(:bad_request) }
    end

    context "when params is empty" do
      before { post "/authentication", params: {}, headers: headers }

      it { expect(JSON.parse(response.body)).to have_key("error") }
      it { expect(JSON.parse(response.body)["error"]["status"]).to match("credentials cant be blank") }
      it { expect(response).to have_http_status(:bad_request) }
    end
  end
end