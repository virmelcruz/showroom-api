class User
  include Mongoid::Document
  include ActiveModel::SecurePassword

  field :name, type: String
  field :email, type: String
  field :first_name, type: String
  field :last_name, type: String
  field :password_digest, type: String
  
  has_secure_password

  has_many :rooms

  validates_presence_of :name, :email, :password_digest

  def full_name
    "#{first_name} #{last_name}"
  end
end