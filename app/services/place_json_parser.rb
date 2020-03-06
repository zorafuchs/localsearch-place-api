require 'net/http'

class PlaceJsonParser
    def initialize (place)
        url = 'https://storage.googleapis.com/coding-session-rest-api/' + place.api_key
        uri = URI(url)
        response = Net::HTTP.get(uri)
        @place_hash = JSON.parse(response)
    end

    def place_json
        JSON.generate(name: place_name, address: place_address, opening_hours: place_opening_hours)
    end

    private def place_name
        @place_hash.dig('addresses', 0, 'business', 'identities', 0, 'name')
    end

    private def place_address
        street = @place_hash.dig('addresses', 0, 'where', 'street')
        number = @place_hash.dig('addresses', 0, 'where', 'house_number')
        zip = @place_hash.dig('addresses', 0, 'where', 'zipcode')
        city = @place_hash.dig('addresses', 0, 'where', 'city')
        "#{street} #{number}, #{zip} #{city}"
    end

    private def place_opening_hours
        opening_hours = []
        days = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday']
        days.each do |day|
            if @place_hash.dig('opening_hours', 'days', day)
                opening_hours.push({ days: day, value: @place_hash.dig('opening_hours', 'days', day).map { |v| "#{v['start']} - #{v['end']}" } })
            else
                opening_hours.push({ days: day, value: ['closed']})
            end
        end
        data_safe = 'monday'
        new_opening_hours = opening_hours.clone
        opening_hours.each_index do |index|
            if (index > 0 && opening_hours[index][:value].to_s == opening_hours[index-1][:value].to_s ) 
                new_opening_hours.delete(opening_hours[index-1])
                new_opening_hours[new_opening_hours.index(opening_hours[index])][:days] = "#{data_safe} - #{opening_hours[index][:days]}"
            else
                data_safe = opening_hours[index][:days]
            end
        end
        new_opening_hours
    end
end
