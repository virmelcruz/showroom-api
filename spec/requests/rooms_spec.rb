require 'rails_helper'
require 'factory_bot'

RSpec.describe "Room API", type: :request do

  let!(:user) { create :user }
  
  before do
    AuthorizeApiRequest.any_instance.stub(:call).and_return({ user: user })
  end

  describe "POST /graphql createRoom(:room_no, :user, :floor) - graphql mutation for creating a room " do
    let! (:floor) { create :floor }
    context "when request is valid" do
      before_count = Room.count
      let(:valid_attributes) { { query: "mutation { createRoom(room_no: \"A01\", user: \"#{user.id}\", floor: \"#{floor.id}\") { id room_no floor { name } } }" } }
      
      before { post "/graphql", params: valid_attributes }
      
      it { expect(response.content_type).to eq("application/json") }
      it { expect(json["data"]["createRoom"]["room_no"]).to match("A01") }
      it { expect(json).not_to have_key("errors") }
      it { expect(response).to have_http_status(:ok) }
      it { expect(Room.count).not_to eq(before_count) }
    end
    
    context "when params is empty" do
      let(:invalid_attributes) { { query: 'mutation { }' } }
      before { post "/graphql", params: invalid_attributes }

      it { expect(json).to have_key("errors") }
      it { expect(response).to have_http_status(:ok) }
    end

    context "when params is blank" do 
      let(:invalid_attributes) { { query: 'mutation { createRoom(room_no: "") { id room_no } }' } }
      before { post "/graphql", params: invalid_attributes }

      it { expect(json).to have_key("errors") }
      it { expect(response).to have_http_status(:ok) }
    end

  end

  describe "POST /graphql :rooms - gets all rooms" do
    let(:valid_attributes) { { query: "query { rooms { id room_no } }" } }
    
    context "when there is rooms" do
      let! (:room) { create :room }
      before { post "/graphql", params: valid_attributes }

      it { expect(json["data"]["rooms"]).to be_an_instance_of(Array) }
      it { expect(json["data"]["rooms"]).not_to be_empty }
      it { expect(json).not_to have_key("errors") }
      it { expect(response).to have_http_status(:ok) }
    end

    context "when there is no rooms at all" do
      before { post "/graphql", params: valid_attributes }
      
      it { expect(json["data"]["rooms"]).to be_an_instance_of(Array) }
      it { expect(json["data"]["rooms"]).to be_empty }
      it { expect(json).not_to have_key("errors") }
      it { expect(response).to have_http_status(:ok) }
    end

  end

  describe "POST /graphql :room - gets specific room" do
    context "when you found the specific room" do
      let! (:room) { create :room }
      let(:valid_attributes) { { query: "query { room(id: \"#{room.id}\"){ id room_no } }" } }

      before { post "/graphql", params: valid_attributes }

      it { expect(json["data"]["room"]["id"]).to match(room.id) }
      it { expect(response.content_type).to eq("application/json") }
      it { expect(json["data"]["room"]).not_to be_empty }
      it { expect(json).not_to have_key("errors") }
      it { expect(response).to have_http_status(:ok) }
    end

    context "when it has no record found" do
      let(:valid_attributes) { { query: "query { room(id: 0){ id room_no } }" } }
      before { post "/graphql", params: valid_attributes }

      it { expect(json).not_to have_key("errors") }
      it { expect(json["data"]["room"]).to be_nil }
      it { expect(response).to have_http_status(:ok) }
    end
  end

  describe "POST /graphql updateRoom(:id, :room_no) - updates a room" do
    
    context "when request is valid" do
      let (:room) { create :room }
      let(:valid_attributes) { { query: "mutation { updateRoom(id: \"#{room.id}\", room_no: \"A001\") { id room_no } }" } }

      before { post "/graphql", params: valid_attributes }
      
      it { expect(response.content_type).to eq("application/json") }
      it { expect(json["data"]["updateRoom"]["id"]).to match(room.id) }
      it { expect(json["data"]["updateRoom"]["room_no"]).to match("A001") }
      it { expect(json).not_to have_key("errors") }
      it { expect(response).to have_http_status(:ok) }
    end

    context "when it has no record found to update" do
      let(:valid_attributes) { { query: "mutation { updateRoom(id: \"0\", room_no: \"A001\") { id room_no } }" } }
      
      before { post "/graphql", params: valid_attributes }

      it { expect(json["data"]["updateRoom"]).to be_nil }
      it { expect(json).not_to have_key("errors") }
      it { expect(response).to have_http_status(:ok) }
    end
  end
  
  describe "POST /graphql deleteRoom(:id) - deletes a room" do
    context "when request is valid" do
      let! (:room) { create :room }
      let(:valid_attributes) { { query: "mutation { deleteRoom(id: \"#{room.id}\") { } }" } }
      before { post "/graphql", params: valid_attributes }
      
      it { expect(response.content_type).to eq("application/json") }
      it { expect(json["data"]["deleteRoom"]).to match(room.id) }
      it { expect(json).not_to have_key("errors") }
      it { expect(response).to have_http_status(:ok) }
      it { expect(Room.count).to eq(0) }
    end

    context "when it has no record found to delete" do
      let(:valid_attributes) { { query: "mutation { deleteRoom(id: \"0\") { } }" } }
      
      before { post "/graphql", params: valid_attributes }

      it { expect(json).not_to have_key("errors") }
      it { expect(json["data"]["deleteRoom"]).to be_nil }
      it { expect(response).to have_http_status(:ok) }
    end
  end

end
