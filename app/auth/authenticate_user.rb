class AuthenticateUser
  def initialize(email, password)
    @email = email
    @password = password
  end

  def call
    if user
      JsonWebToken.encode(user_id: user._id)
    end
  end

  private
  def user
    user = User.find_by(email: @email)
    if user && user.authenticate(@password)
      return user
    end
  end
end