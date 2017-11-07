require 'rails_helper'

RSpec.describe Floor, type: :model do
  it "validates presence" do
    expect(Floor.create!(name: "test123")).to be_valid
  end
end
