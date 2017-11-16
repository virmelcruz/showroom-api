class Room
  include Mongoid::Document

  field :room_no, type: String
  
  belongs_to :floor
  belongs_to :user, optional: true
  
  validates :room_no, :presence => true
end
