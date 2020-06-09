# app/controllers/api/v1/restaurants_controller.rb
class Api::V1::RestaurantsController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User, except: [ :index, :show ]
  before_action :set_restaurant, only: [ :show, :update, :destroy]
  def index
    @restaurants = policy_scope(Restaurant)
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    @restaurant.user = current_user
    authorize @restaurant

    if @restaurant.save
      #successful creation
      render :show, status: :created
    else
      #unsuccessful
      render_error
    end
  end
  def show; end

  def update
    if @restaurant.update(restaurant_params)
      # successful update
      render :show
    else
      # unsuccesful update
      render_error
    end
  end

  def destroy
    @restaurant.destroy
    # head :no_content
    render json: { message: "YOU DID IT, YOU SUCCESSFULLY CRUDDED YOUR PANTS"}
  end

  private

  def restaurant_params
    params.require(:restaurant).permit(:name, :address)
  end

  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
    authorize @restaurant # for pundit
  end

  def render_error
    render json: { errors: @restaurant.errors.full_messages },
      status: :unprocessable_entity
  end
end
