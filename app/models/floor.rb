class Floor
  include Mongoid::Document
  
  field :name, type: String
  
  embeds_many :rooms

  validates :name, :presence => true
end
