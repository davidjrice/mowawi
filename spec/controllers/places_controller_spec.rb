require File.dirname(__FILE__) + '/../spec_helper'

describe PlacesController, "#route_for" do

  it "should map { :controller => 'places', :action => 'index' } to /places" do
    route_for(:controller => "places", :action => "index").should == "/places"
  end
  
  it "should map { :controller => 'places', :action => 'new' } to /places/new" do
    route_for(:controller => "places", :action => "new").should == "/places/new"
  end
  
  it "should map { :controller => 'places', :action => 'show', :id => 1 } to /places/1" do
    route_for(:controller => "places", :action => "show", :id => 1).should == "/places/1"
  end
  
  it "should map { :controller => 'places', :action => 'edit', :id => 1 } to /places/1;edit" do
    route_for(:controller => "places", :action => "edit", :id => 1).should == "/places/1;edit"
  end
  
  it "should map { :controller => 'places', :action => 'update', :id => 1} to /places/1" do
    route_for(:controller => "places", :action => "update", :id => 1).should == "/places/1"
  end
  
  it "should map { :controller => 'places', :action => 'destroy', :id => 1} to /places/1" do
    route_for(:controller => "places", :action => "destroy", :id => 1).should == "/places/1"
  end
  
end

describe PlacesController, "handling GET /places" do

  before do
    @place = mock_model(Place)
    Place.stub!(:find).and_return([@place])
  end
  
  def do_get
    get :index
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end

  it "should render index template" do
    do_get
    response.should render_template('index')
  end
  
  it "should find all places" do
    Place.should_receive(:find).with(:all).and_return([@place])
    do_get
  end
  
  it "should assign the found places for the view" do
    do_get
    assigns[:places].should == [@place]
  end
end

describe PlacesController, "handling GET /places.xml" do

  before do
    @place = mock_model(Place, :to_xml => "XML")
    Place.stub!(:find).and_return(@place)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :index
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end

  it "should find all places" do
    Place.should_receive(:find).with(:all).and_return([@place])
    do_get
  end
  
  it "should render the found places as xml" do
    @place.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

describe PlacesController, "handling GET /places/1" do

  before do
    @place = mock_model(Place, :nearby => [], :photos => [])
    @controller.should_receive(:setup_google_map_for).with(@place)
    Place.stub!(:find).and_return(@place)
  end
  
  def do_get
    get :show, :id => "1"
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should render show template" do
    do_get
    response.should render_template('show')
  end
  
  it "should find the place requested" do
    Place.should_receive(:find).with("1").and_return(@place)
    do_get
  end
  
  it "should assign the found place for the view" do
    do_get
    assigns[:place].should equal(@place)
  end
end

describe PlacesController, "handling GET /places/1.xml" do

  before do
    @place = mock_model(Place, :nearby => [], :to_xml => "XML", :photos => [])
    @controller.should_receive(:setup_google_map_for).with(@place)
    Place.stub!(:find).and_return(@place)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :show, :id => "1"
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should find the place requested" do
    Place.should_receive(:find).with("1").and_return(@place)
    do_get
  end
  
  it "should render the found place as xml" do
    @place.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

describe PlacesController, "handling GET /places/new" do

  before do
    @place = mock_model(Place)
    Place.stub!(:new).and_return(@place)
  end
  
  def do_get
    get :new
  end
  
  it "should be successful when logged in" do
    do_login
    do_get
    response.should be_success
  end
  
  it "should be redirect when not logged in" do
    do_get
    response.should redirect_to('/session/new')
  end
  
  it "should render new template" do
    do_login
    do_get
    response.should render_template('new')
  end
  
  it "should create an new place" do
    do_login
    Place.should_receive(:new).and_return(@place)
    do_get
  end
  
  it "should not save the new place" do
    do_login
    @place.should_not_receive(:save)
    do_get
  end
  
  it "should assign the new place for the view" do
    do_login
    do_get
    assigns[:place].should equal(@place)
  end
end

describe PlacesController, "handling GET /places/1/edit" do

  before do
    @place = mock_model(Place)
    Place.stub!(:find).and_return(@place)
  end
  
  def do_get
    get :edit, :id => "1"
  end

  it "should be successful when logged in" do
    do_login
    do_get
    response.should be_success
  end
  
  it "should redirect to login if not logged in" do
    do_get
    response.should redirect_to('/session/new')
  end
  
  it "should render edit template" do
    do_login
    do_get
    response.should render_template('edit')
  end
  
  it "should find the place requested" do
    Place.should_receive(:find).and_return(@place)
    do_login
    do_get
  end
  
  it "should assign the found Place for the view" do
    do_login
    do_get
    assigns[:place].should equal(@place)
  end
end

describe PlacesController, "handling POST /places" do

  before do
    @place = mock_model(Place, :to_param => "1")
    Place.stub!(:new).and_return(@place)
    @user = mock_model(User)
    @controller.stub!(:current_user).and_return(@user)
  end
  
  def post_with_successful_save
    @place.should_receive(:save).and_return(true)
    @place.should_receive(:user_id=)
    post :create, :place => {}
  end
  
  def post_with_failed_save
    @place.should_receive(:save).and_return(false)
    @place.should_receive(:user_id=)
    post :create, :place => {}
  end
  
  it "should not create a new place if not logged in" do
    Place.should_receive(:new).with({}).and_return(@place)
    post_with_successful_save
  end
  
  it "should create a new place" do
    do_login
    Place.should_receive(:new).with({}).and_return(@place)
    post_with_successful_save
  end

  it "should redirect to the new place on successful save" do
    do_login
    post_with_successful_save
    response.should redirect_to(place_url("1"))
  end

  it "should re-render 'new' on failed save" do
    do_login
    post_with_failed_save
    response.should render_template('new')
  end
end

describe PlacesController, "handling PUT /places/1" do

  before do
    @place = mock_model(Place, :to_param => "1")
    Place.stub!(:find).and_return(@place)
  end
  
  def put_with_successful_update
    @place.should_receive(:update_attributes).and_return(true)
    put :update, :id => "1"
  end
  
  def put_with_failed_update
    @place.should_receive(:update_attributes).and_return(false)
    put :update, :id => "1"
  end
  
  it "should redirect if not logged in" do
    put :update, :id => "1"
    response.should redirect_to('/session/new')
  end
  
  it "should find the place requested if logged in" do
    do_login
    Place.should_receive(:find).with("1").and_return(@place)
    put_with_successful_update
  end

  it "should update the found place" do
    do_login
    put_with_successful_update
    assigns(:place).should equal(@place)
  end

  it "should assign the found place for the view" do
    do_login
    put_with_successful_update
    assigns(:place).should equal(@place)
  end

  it "should redirect to the place on successful update" do
    do_login
    put_with_successful_update
    response.should redirect_to(place_url("1"))
  end

  it "should re-render 'edit' on failed update" do
    do_login
    put_with_failed_update
    response.should render_template('edit')
  end
end

describe PlacesController, "handling DELETE /places/1" do

  before do
    @place = mock_model(Place, :destroy => true)
    Place.stub!(:find).and_return(@place)
  end
  
  def do_delete
    delete :destroy, :id => "1"
  end

  it "should redirect if not logged in" do
    do_delete
    response.should redirect_to('/session/new')
  end
  
  it "should find the place requested" do
    do_login
    Place.should_receive(:find).with("1").and_return(@place)
    do_delete
  end
  
  it "should call destroy on the found place" do
    do_login
    @place.should_receive(:destroy)
    do_delete
  end
  
  it "should redirect to the places list" do
    do_login
    do_delete
    response.should redirect_to(places_url)
  end
end
