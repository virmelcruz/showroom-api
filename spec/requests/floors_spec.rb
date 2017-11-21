require 'rails_helper'
require 'factory_bot'

RSpec.describe "Floor API", type: :request do

  let!(:user) { create :user }
  
  before do
    AuthorizeApiRequest.any_instance.stub(:call).and_return({ user: user })
  end

  describe "POST /graphql createFloor(:name) - graphql mutation for creating a floor " do
    
    context "when request is valid" do
      before_count = Floor.count
      let(:valid_attributes) { { query: 'mutation { createFloor(name: "007") { id name } }' } }
      
      before { post "/graphql", params: valid_attributes }
      
      it { expect(response.content_type).to eq("application/json") }
      it { expect(json["data"]["createFloor"]["name"]).to match("007") }
      it { expect(json).not_to have_key("errors") }
      it { expect(response).to have_http_status(:ok) }
      it { expect(Floor.count).not_to eq(before_count) }
    end
    
    context "when params is empty" do
      let(:invalid_attributes) { { query: 'mutation { }' } }
      before { post "/graphql", params: invalid_attributes }

      it { expect(json).to have_key("errors") }
      it { expect(response).to have_http_status(:ok) }
    end

    context "when params is blank" do 
      let(:invalid_attributes) { { query: 'mutation { createFloor(name: "") { id name } }' } }
      before { post "/graphql", params: invalid_attributes }

      it { expect(json).to have_key("errors") }
      it { expect(response).to have_http_status(:ok) }
    end

  end

  describe "POST /graphql :floors - gets all floors" do
    let(:valid_attributes) { { query: "query { floors { id name } }" } }
    context "when there is floors" do
      let! (:floor) { create :floor }
      before { post "/graphql", params: valid_attributes }

      it { expect(json["data"]["floors"]).to be_an_instance_of(Array) }
      it { expect(json["data"]["floors"]).not_to be_empty }
      it { expect(json).not_to have_key("errors") }
      it { expect(response).to have_http_status(:ok) }
    end

    context "when there is no floors at all" do
      before { post "/graphql", params: valid_attributes }
      
      it { expect(json["data"]["floors"]).to be_an_instance_of(Array) }
      it { expect(json["data"]["floors"]).to be_empty }
      it { expect(json).not_to have_key("errors") }
      it { expect(response).to have_http_status(:ok) }
    end

  end

  describe "POST /graphql :floor - gets specific floor" do
    context "when you found the specific floor" do
      let! (:floor) { create :floor }
      let(:valid_attributes) { { query: "query { floor(id: \"#{floor.id}\"){ id name } }" } }

      before { post "/graphql", params: valid_attributes }

      it { expect(json["data"]["floor"]["id"]).to match(floor.id) }
      it { expect(response.content_type).to eq("application/json") }
      it { expect(json["data"]["floor"]).not_to be_empty }
      it { expect(json).not_to have_key("errors") }
      it { expect(response).to have_http_status(:ok) }
    end

    context "when it has no record found" do
      let(:valid_attributes) { { query: "query { floor(id: 0){ id name } }" } }
      before { post "/graphql", params: valid_attributes }

      it { expect(json).not_to have_key("errors") }
      it { expect(json["data"]["floor"]).to be_nil }
      it { expect(response).to have_http_status(:ok) }
    end
  end

  describe "POST /graphql updateFloor(:id, :name) - updates a floor" do
    
    context "when request is valid" do
      let (:floor) { create :floor }
      let(:valid_attributes) { { query: "mutation { updateFloor(id: \"#{floor.id}\", name: \"007\") { id name } }" } }

      before { post "/graphql", params: valid_attributes }
      
      it { expect(response.content_type).to eq("application/json") }
      it { expect(json["data"]["updateFloor"]["id"]).to match(floor.id) }
      it { expect(json["data"]["updateFloor"]["name"]).to match("007") }
      it { expect(json).not_to have_key("errors") }
      it { expect(response).to have_http_status(:ok) }
    end

    context "when it has no record found to update" do
      let(:valid_attributes) { { query: "mutation { updateFloor(id: \"0\", name: \"007\") { id name } }" } }
      
      before { post "/graphql", params: valid_attributes }

      it { expect(json["data"]["updateFloor"]).to be_nil }
      it { expect(json).not_to have_key("errors") }
      it { expect(response).to have_http_status(:ok) }
    end
  end
  
  describe "POST /graphql deleteFloor(:id) - deletes a floor" do
    context "when request is valid" do
      let! (:floor) { create :floor }
      let(:valid_attributes) { { query: "mutation { deleteFloor(id: \"#{floor.id}\") { } }" } }
      before { post "/graphql", params: valid_attributes }
      
      it { expect(response.content_type).to eq("application/json") }
      it { expect(json["data"]["deleteFloor"]).to match(floor.id) }
      it { expect(json).not_to have_key("errors") }
      it { expect(response).to have_http_status(:ok) }
      it { expect(Floor.count).to eq(0) }
    end

    context "when it has no record found to delete" do
      let(:valid_attributes) { { query: "mutation { deleteFloor(id: \"0\") { } }" } }
      
      before { post "/graphql", params: valid_attributes }

      it { expect(json).not_to have_key("errors") }
      it { expect(json["data"]["deleteFloor"]).to be_nil }
      it { expect(response).to have_http_status(:ok) }
    end
  end

end
