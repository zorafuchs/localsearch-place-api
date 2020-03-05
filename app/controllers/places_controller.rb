class PlacesController < ApplicationController

    def show
        render json: PlaceJsonParser.new(Place.find(params[:id])).place_json
    end
end
