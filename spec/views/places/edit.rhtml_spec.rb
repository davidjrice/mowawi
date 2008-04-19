require File.dirname(__FILE__) + '/../../spec_helper'

describe "/places/edit.rhtml" do
  include PlacesHelper
  
  before do
    @place = mock_model(Place, :title => "Test", :lat => 50.1, :lng => 5.0)
    assigns[:place] = @place
  end

  it "should render edit form" do
    render "/places/edit.rhtml"
    
    response.should have_tag("form[action=#{place_path(@place)}][method=post]") do
    end
  end
end


