require 'rails_helper'

RSpec.describe AuthenticateUser do
  let!(:user) { create :user }
  let!(:valid_auth_obj) { described_class.new(user.email, user.password) }
  let!(:invalid_auth_obj) { described_class.new('foo', 'bar') }

  describe "#call" do
    context "when valid credentials" do
      it { expect(valid_auth_obj.call).not_to be nil }
    end

    context "when it has invalid credentials" do 
      it { expect(invalid_auth_obj.call).to be nil }
    end
  end
end