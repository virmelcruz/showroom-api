FactoryBot.define do
  factory :floor do
    name { FFaker::Random.rand(01..99).to_s }
  end
end
