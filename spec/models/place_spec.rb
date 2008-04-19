require File.dirname(__FILE__) + '/../spec_helper'

describe Place do
  
  def valid_place_attributes
    {:title => "title", :lat => 102.0, :lng => 50.3 }
  end
  
  before(:each) do
    @place = Place.new
  end

  it "should be valid" do
    @place.attributes = valid_place_attributes
    @place.should be_valid
  end
end
