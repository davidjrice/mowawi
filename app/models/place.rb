class Place < ActiveRecord::Base
  include GeoKit::Geocoders
  
  has_many :photos
  acts_as_mappable :default_units => :kms,
                   :default_formula => :sphere,
                   :distance_field_name => :distance
  
  validates_presence_of :title, :address
  validates_numericality_of :lat, :allow_nil => true
  validates_numericality_of :lng, :allow_nil => true
  
  validate :geocode_address
  
  def nearby(distance=500)
    nearby_places = self.class.find(:all, :origin => self, :within => distance)
    nearby_places.delete_if {|place| place == self }
    nearby_places.sort_by_distance_from(self)
  end
  
  def to_param
    "#{self.id}-#{self.title}"
  end
  
  def geocode_required?
    self.lat.nil? || self.lng.nil?
  end
  
  def geocode_address
    return unless geocode_required?
    return if address.nil? || address.blank?
    response = MultiGeocoder.geocode(self.address)
    response.ll # ll=latitude,longitude
    unless response.ll.to_s == "," # no geo-code
      values = response.ll.to_s.split(',')
      self.lat = values[0]
      self.lng = values[1]
    else
      self.errors.add(:address," unable to geocode, try re-entering or using coordinates")
    end
  end
    
end
