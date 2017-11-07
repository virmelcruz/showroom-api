class AuthorizeApiRequest
  def initialize(headers = {})
    @headers = headers
  end

  def call
    user
  end

  private
  def user
    if decoded_auth_token
      if decoded_auth_token[:error].present?
        decoded_auth_token
      else
        @user ||= User.find(decoded_auth_token[:user_id])
        if @user
          {
            user: @user
          }
        else
          {
            error: {
              "status": "invalid token",
              "message": "Invalid Token"
            }
          }
        end
      end
    else
      {
        error: {
          "status": "missing token",
          "message": "No Token Available"
        }
      }
    end
  end

  def decoded_auth_token #method that will return or not
    if http_auth_header.present? #will return hash if valid or expired
      @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)

      if @decoded_auth_token.is_a?(Hash)
        @decoded_auth_token
      else
        {
          error: {
            "status": "expired token",
            "message": @decoded_auth_token
          }
        }
      end
    end
  end

  def http_auth_header
    if @headers[:Authorization].present?
      return @headers[:Authorization]
    end
  end
end