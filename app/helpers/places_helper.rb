module PlacesHelper
  
  def display_place_with_distance(place)
    text = "#{place.title}"
    distance_in_km = place.distance.to_f
    if distance_in_km < 1.0
      distance_in_metres = distance_in_km * 1000
      text += " #{distance_in_metres.round} metres"
    else
      text += " #{distance_in_km.round_to(2)} kilometres"
    end
  end
  
end
