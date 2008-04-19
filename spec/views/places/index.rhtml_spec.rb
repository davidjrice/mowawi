require File.dirname(__FILE__) + '/../../spec_helper'

describe "/places/index.rhtml" do
  include PlacesHelper
  
  before do
    place_98 = mock_model(Place, :id => 98, :title => "Test", :lat => 50.1, :lng => 5.0)    
    place_99 = mock_model(Place, :id => 99, :title => "Test", :lat => 50.1, :lng => 5.0)    
    @controller.template.stub!(:logged_in?).and_return(false)
    assigns[:places] = [place_98, place_99]
  end

  it "should render list of places" do
    render "/places/index.rhtml"
  end
end

