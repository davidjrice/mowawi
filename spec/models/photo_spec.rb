require File.dirname(__FILE__) + '/../spec_helper'

describe Photo do
  
  def valid_photo_attributes
    {:user_id => 1, :place_id => 1}
  end
  
  before(:each) do
    @photo = Photo.new
  end

  it "should be valid" do
    pending "need to figure specs for has_attachment"
    @photo.attributes = valid_photo_attributes
    @photo.should be_valid
  end
end
