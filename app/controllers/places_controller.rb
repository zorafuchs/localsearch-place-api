class PlacesController < ApplicationController
    def show
        @place = Place.find(params[:id])
        render json: @place
    end
end
