require File.dirname(__FILE__) + '/../../spec_helper'

describe "/users/show.rhtml" do
  include UsersHelper
  
  before(:each) do
    @user = mock_user
    @controller.template.stub!(:logged_in?).and_return(false)
    @user.stub!(:places).and_return([])
    assigns[:user] = @user
    
  end

  it "should render attributes in <p>" do
    render "/users/show.rhtml"

  end
end

