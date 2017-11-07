require 'rails_helper'
require 'factory_bot'

RSpec.describe Room, type: :model do
  let(:floor) { create :floor }
  let(:room) { Room.create!(room_no: "001", floor: floor) }
  it { expect(room).to be_valid }
end

