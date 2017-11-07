class Room
  include Mongoid::Document

  field :room_no, type: String
  
  embedded_in :floor

  validates :room_no, :presence => true
end
