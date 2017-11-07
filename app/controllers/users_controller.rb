class UsersController < ApplicationController
  skip_before_action :authorize_request, only: :create
  
  def create
    if params
      user = User.new(user_params)

      if user.save
        render json: user, status: :created
      else
        render json: {message: user.errors.full_messages.to_sentence }, status: :bad_request
      end
    else
      render status: :bad_request 
    end
  end

  private
  def user_params
    params.fetch(:user, {}).permit(:name, :email, :password)
  end
end