require File.dirname(__FILE__) + '/../../spec_helper'

describe "/photos/edit.rhtml" do
  include PhotosHelper
  
  before do
    @photo = mock_model(Photo)
    assigns[:photo] = @photo
    @place = mock_model(Place)
    assigns[:place] = @place
  end

  it "should render edit form" do
    render "/photos/edit.rhtml"
    
    response.should have_tag("form[action=#{photo_path(@place,@photo)}][method=post]") do
    end
  end
end


