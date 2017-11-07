class FloorsController < ApplicationController

  def index
    render json: Floor.all || []
  end

  def show
    floor = Floor.find(params[:id])
    if floor
        render json: floor, status: :ok
    else
        render status: :not_found
    end
  end

  def create
    if params
      floor = Floor.new(floor_params)

      if floor.save
        render json: floor, status: :created
      else
        render json: {message: floor.errors.full_messages.to_sentence }, status: :bad_request
      end
    else
      render status: :bad_request 
    end
  end

  def update
    floor = Floor.find(params[:id])

    if floor && floor.update_attributes(floor_params)
      render json: floor, status: :ok
    else
      render status: :not_found
    end
  end

  def destroy
    floor = Floor.find(params[:id])

    if floor && floor.destroy
      render status: :ok
    else
      render status: :not_found
    end
  end

  private
  def floor_params
    params.fetch(:floor, {}).permit(:name)
  end
end