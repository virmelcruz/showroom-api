class AuthenticationController < ApplicationController
  skip_before_action :authorize_request, only: :create

  def create
    if auth_params[:email].present?
      auth_token = AuthenticateUser.new(auth_params[:email], auth_params[:password]).call
      if auth_token
        render json: { token: auth_token }, status: :ok
      else
        render json: { error: { status: "invalid credentials", message: "Wrong email/password" } }, status: :bad_request
      end
    else
      render json: { error: { status: "credentials cant be blank", message: "Credentials cant be blank" } }, status: :bad_request
    end
  end

  private
  def auth_params
    params.fetch(:user, {}).permit(:email, :password)
  end
end