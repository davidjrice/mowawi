require File.dirname(__FILE__) + '/../../spec_helper'

describe "/users/new.rhtml" do
  include UsersHelper
  
  before(:each) do
    @errors = mock("errors")
    @errors.stub!(:count).and_return(0)

    @user = mock_user
    @user.stub!(:openid?).and_return false
    @user.stub!(:errors).and_return @errors
    assigns[:user] = @user
  end

  it "should render new form" do
    render "/users/new.rhtml"
    response.should have_tag('form', :attributes =>{:action => users_path, :method => 'post'})

  end
end


