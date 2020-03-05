class PlaceJsonParser
    def initialize (place)
        @place = place
    end

    def place_json
        @place.to_json
    end

end
