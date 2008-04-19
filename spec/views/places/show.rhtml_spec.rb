require File.dirname(__FILE__) + '/../../spec_helper'

describe "/places/show.rhtml" do
  include PlacesHelper
  
  before do
    @place = mock_model(Place, :id => 1, :title => "Test", :lat => 50.1, :lng => 5.0)    
    assigns[:nearby] = []
    assigns[:place] = @place
  end

  it "should render attributes in <p>" do
    render "/places/show.rhtml"
  end
end

