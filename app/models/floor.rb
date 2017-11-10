class Floor
  include Mongoid::Document
  
  field :name, type: String
  
  has_many :rooms

  validates :name, :presence => true
end
