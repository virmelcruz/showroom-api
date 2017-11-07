class ApplicationController < ActionController::API

  before_action :authorize_request
  attr_reader :current_user

  private
  
  def authorize_request
    api_request = (AuthorizeApiRequest.new(request.headers).call)
    
      @current_user = api_request[:user]
      render_error(api_request[:error]) if @current_user.nil?
  end

  def render_error(errors)
    render json: errors, status: :unauthorized
  end
end
