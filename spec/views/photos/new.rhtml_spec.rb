require File.dirname(__FILE__) + '/../../spec_helper'

describe "/photos/new.rhtml" do
  include PhotosHelper
  
  before do
    @photo = mock_model(Photo)
    @photo.stub!(:new_record?).and_return(true)
    assigns[:photo] = @photo
    @place = mock_model(Place)
    assigns[:place] = @place
  end

  it "should render new form" do
    render "/photos/new.rhtml"
    
    response.should have_tag("form[action=?][method=post]", photos_path(@place)) do
    end
  end
end


