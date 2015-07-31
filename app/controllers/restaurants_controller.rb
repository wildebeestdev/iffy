class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: [:show, :update, :destroy]

  def index

    @ll     = '33.9716350,-118.4499780'
    @terms  = 'lunch'
    @radius = '10000'
    @limit  = 12
    client  = Foursquare2::Client.new(:client_id => ENV["FOURSQUARE_ID"], :client_secret => ENV["FOURSQUARE_SECRET"], :api_version => '20140806')
    @restaurants = client.explore_venues(ll: @ll, query: 'lunch, '+ @terms, venuePhotos: true, limit: @limit, radius: @radius)

    render json: @restaurants 
  end

  def show
    render json: @restaurant
  end

  def restaurant
# binding.pry
    # @ll     = params[:ll]
    @ll     = '33.971677299999996, -118.4500588'
    @terms  = params[:terms]
    @radius = '10000'
    @limit  = 12
    client  = Foursquare2::Client.new(:client_id => ENV["FOURSQUARE_ID"], :client_secret => ENV["FOURSQUARE_SECRET"], :api_version => '20140806')
    @restaurants = client.explore_venues(ll: @ll, query: 'lunch, '+@terms, venuePhotos: true, radius: @radius, limit: @limit)

      render json: @restaurants
 
  end

  def create
  end
  def update

    @restaurant = Restaurant.find(params[:id])

    if @restaurant.update(restaurant_params)
      head :no_content
    else
      render json: @restaurant.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @restaurant.destroy

    head :no_content
  end

  private

    def set_restaurant
      @restaurant = Restaurant.find(params[:id])
    end

    def restaurant_params
      params.require(:restaurant).permit(:term)
    end
end
