module ControllerSpecHelper

  def token_generator(user_id, isValid)
    isValid ? JsonWebToken.encode(user_id: user_id) : JsonWebToken.encode({ user_id: user_id}, (Time.now.to_i - 10))
  end

  def valid_headers
    {
      "Authorization": token_generator(user.id, true),
      "ACCEPT": "application/json"
    }
  end

  def invalid_headers
    {
      "Authorization": nil,
      "Content-type": "application/json"
    }
  end

end