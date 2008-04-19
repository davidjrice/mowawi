require File.dirname(__FILE__) + '/../../spec_helper'

describe "/places/new.rhtml" do
  include PlacesHelper
  
  before do
    @place = mock_model(Place, :id => 1, :title => "", :lat => nil, :lng => nil)    
    @place.stub!(:new_record?).and_return(true)
    assigns[:place] = @place
  end

  it "should render new form" do
    render "/places/new.rhtml"
    
    response.should have_tag("form[action=?][method=post]", places_path) do
    end
  end
end


