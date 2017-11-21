require 'rails_helper'
require 'factory_bot'

RSpec.describe "User API", type: :request do
  
  let!(:user) { create :user }
  
  before do
    AuthorizeApiRequest.any_instance.stub(:call).and_return({ user: user })
  end

  describe "POST /graphql createUser(:name, :email, :password) - graphql mutation for creating a user " do
    
    context "when request is valid" do
      before_count = User.count
      let(:valid_attributes) { { query: "mutation { createUser(name: \"vipogi\", email: \"vipogi@medifi.co\", password: \"1234qwer\") { id name } }" } }
      
      before { post "/graphql", params: valid_attributes }
      
      it { expect(response.content_type).to eq("application/json") }
      it { expect(json["data"]["createUser"]["name"]).to match("vipogi") }
      it { expect(json).not_to have_key("errors") }
      it { expect(response).to have_http_status(:ok) }
      it { expect(User.count).not_to eq(before_count) }
    end
    
    context "when params is empty" do
      let(:invalid_attributes) { { query: 'mutation { }' } }
      before { post "/graphql", params: invalid_attributes }

      it { expect(json).to have_key("errors") }
      it { expect(response).to have_http_status(:ok) }
    end

    context "when params is blank" do 
      let(:invalid_attributes) { { query: 'mutation { createUser(name: "", email: "", password: "") { id name } }' } }
      before { post "/graphql", params: invalid_attributes }

      it { expect(json).to have_key("errors") }
      it { expect(response).to have_http_status(:ok) }
    end
  end

  describe "POST /graphql :users - gets all users" do
    let(:valid_attributes) { { query: "query { users { id name email } }" } }
    
    context "when there is users" do
      let! (:user) { create :user }
      before { post "/graphql", params: valid_attributes }

      it { expect(json["data"]["users"]).to be_an_instance_of(Array) }
      it { expect(json["data"]["users"]).not_to be_empty }
      it { expect(json).not_to have_key("errors") }
      it { expect(response).to have_http_status(:ok) }
    end
  end
  
  describe "POST /graphql :user - gets specific user" do
    context "when you found the specific user" do
      let! (:user) { create :user }
      let(:valid_attributes) { { query: "query { user(id: \"#{user.id}\"){ id name } }" } }

      before { post "/graphql", params: valid_attributes }

      it { expect(json["data"]["user"]["id"]).to match(user.id) }
      it { expect(response.content_type).to eq("application/json") }
      it { expect(json["data"]["user"]).not_to be_empty }
      it { expect(json).not_to have_key("errors") }
      it { expect(response).to have_http_status(:ok) }
    end

    context "when it has no record found" do
      let(:valid_attributes) { { query: "query { user(id: 0){ id name } }" } }
      before { post "/graphql", params: valid_attributes }

      it { expect(json).not_to have_key("errors") }
      it { expect(json["data"]["user"]).to be_nil }
      it { expect(response).to have_http_status(:ok) }
    end
  end
end