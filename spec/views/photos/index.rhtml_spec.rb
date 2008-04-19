require File.dirname(__FILE__) + '/../../spec_helper'

describe "/photos/index.rhtml" do
  include PhotosHelper
  
  before do
    photo_98 = mock_model(Photo, :public_filename => "/image.jpg")
    photo_99 = mock_model(Photo, :public_filename => "/image.jpg")
    assigns[:place] = mock_model(Place)
    assigns[:photos] = [photo_98, photo_99]
  end

  it "should render list of photos" do
    render "/photos/index.rhtml"
  end
end

