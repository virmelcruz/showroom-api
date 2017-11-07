require 'rails_helper'

RSpec.describe User, type: :model do
  it { expect(User.create!(name: 'vipogi', email: "test@medifi.co", password: "1234qwer")).to be_valid }
end
