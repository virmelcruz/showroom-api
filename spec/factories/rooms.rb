FactoryBot.define do
  factory :room do
    room_no { FFaker::Random.rand(01..10).to_s }
    floor { FactoryBot.create :floor }
  end
end
