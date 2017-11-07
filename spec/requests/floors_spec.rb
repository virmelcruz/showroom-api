require 'rails_helper'
require 'factory_bot'

RSpec.describe "Floor API", type: :request do
  headers = {
      "ACCEPT": "application/json"
  }

  let!(:user) { create :user }
  
  before do
    AuthorizeApiRequest.any_instance.stub(:call).and_return({ user: user })
  end

  describe "POST /floor.json - creates a floor " do
    context "when request is valid" do
      before_count = Floor.count
      let(:valid_attributes) { { floor: { name: "01" } } }
      before { post "/floors", params: valid_attributes , headers: headers }

      it { expect(response.content_type).to eq("application/json") }
      it { expect(JSON.parse(response.body)["name"]).to match("01") }
      it { expect(response).to have_http_status(:created) }
      it { expect(Floor.count).not_to eq(before_count) }
    end
    
    context "when params is empty" do
      let(:invalid_attributes) { { floor: { } } }
      before { post "/floors", params: invalid_attributes, headers: headers }
      it { expect(response).to have_http_status(:bad_request) }
    end

    context "when params is blank" do 
      let(:invalid_attributes) { { floor: { name: "" } } }
      before { post "/floors", params: invalid_attributes, headers: headers }
      it { expect(response).to have_http_status(:bad_request) }
    end

  end

  describe "GET /floor.json - gets all floors" do
    context "when there is floors" do
      let! (:floor) { create :floor }
      before { get "/floors.json"  }

      it { expect(JSON.parse(response.body)).to be_an_instance_of(Array) } 
      it { expect(JSON.parse(response.body)).not_to be_empty }
      it { expect(response).to have_http_status(:ok) }
    end

    context "when there is no floors at all" do
      before { get "/floors.json"  }
      it { expect(JSON.parse(response.body)).to be_an_instance_of(Array) }
      it { expect(JSON.parse(response.body)).to be_empty }
      it { expect(response).to have_http_status(:ok) }
    end
  end

  describe "GET /floor/:id.json - gets specific floor" do
    context "when you found the specific floor" do
      let! (:floor) { create :floor }
      before { get "/floors/#{floor.id}.json" }
      
      it { expect( JSON.parse(response.body)["_id"]["$oid"]).to match(floor.id) }
      it { expect(response.content_type).to eq("application/json") }
      it { expect(response.body).not_to be_empty }
      it { expect(response).to have_http_status(:ok) }
    end

    context "when it has no record found" do
      before { get "/floors/0.json" }
      it { expect(response).to have_http_status(:not_found) }
    end
  end

  describe "PUT/PATCH /floors/:id.json - updates a floor" do
    let (:valid_attributes) { { floor: { name: "02" } } }
    
    context "when request is valid" do
      let (:floor) { create :floor }
      before { put "/floors/#{floor.id}", params: valid_attributes, headers: headers }
      
      it { expect(response.content_type).to eq("application/json") }
      it { expect(JSON.parse(response.body)["name"]).to match("02") }
      it { expect(response).to have_http_status(:ok) }
    end

    context "when it has no record found to update" do
      before { put "/floors/0", params: valid_attributes, headers: headers }
      it { expect(response).to have_http_status(:not_found) }
    end
  end
  
  describe "DELETE /floors/:id.json - deletes a floor" do
    context "when request is valid" do
      let! (:floor) { create :floor }
      before { delete "/floors/#{floor.id}", headers: headers }
      
      it { expect(response).to have_http_status(:ok) }
      it { expect(Floor.count).to eq(0) }
    end

    context "when it has no record found to delete" do
      before { delete "/floors/0", headers: headers }
      it { expect(response).to have_http_status(:not_found) }
    end
  end

end
