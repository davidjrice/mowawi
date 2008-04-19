require File.dirname(__FILE__) + '/../../spec_helper'

describe "/photos/show.rhtml" do
  include PhotosHelper
  
  before do
    @photo = mock_model(Photo)
    assigns[:photo] = @photo
    @place = mock_model(Place)
    assigns[:place] = @place
  end

  it "should render attributes in <p>" do
    render "/photos/show.rhtml"
  end
end

