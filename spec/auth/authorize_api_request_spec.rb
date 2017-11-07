require 'rails_helper'
require 'factory_bot'

RSpec.describe AuthorizeApiRequest do

  NO_TOKEN = {
    "status": "missing token",
    "message": "No Token Available"
  }

  INVALID_TOKEN = {
    "status": "invalid token",
    "message": "Invalid Token"
  }

  EXPIRED_TOKEN = {
      "status": "expired token",
      "message": "Signature has expired"
  }
  
  let!(:user) { create :user }
  let!(:header) { { "Authorization": token_generator(user._id, true) } }
  let!(:invalid_request_obj) { described_class.new({}) }
  let!(:valid_request_obj) do
    described_class.new(header)
  end

  describe "#call" do
    context "when valid request" do
      it { expect(valid_request_obj.call[:user]).to eq(user) }
    end

    context "when it has no token" do
      it do
        expect(invalid_request_obj.call[:error]).to eq(NO_TOKEN)
      end
    end

    context "when it has invalid token" do
      let!(:invalid_request_obj) { described_class.new( "Authorization": token_generator(5, true) ) }
      it { expect(invalid_request_obj.call[:error]).to be(INVALID_TOKEN) }
    end

    context "when it has expired token" do
      let!(:invalid_request_obj) { described_class.new( "Authorization": token_generator(user._id, false) ) }
      it { expect(invalid_request_obj.call[:error]).to eq(EXPIRED_TOKEN) }
    end
  end
end