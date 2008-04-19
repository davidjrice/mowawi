require File.dirname(__FILE__) + '/../spec_helper'

describe PhotosController, "#route_for" do

  it "should map { :controller => 'photos', :action => 'index', :place_id => 1} to /places/1/photos" do
    route_for(:controller => "photos", :action => "index", :place_id => 1).should == "/places/1/photos"
  end
  
  it "should map { :controller => 'photos', :action => 'new', :place_id => 1 } to /places/1/photos/new" do
    route_for(:controller => "photos", :action => "new", :place_id => 1).should == "/places/1/photos/new"
  end
  
  it "should map { :controller => 'photos', :action => 'show', :id => 1, :place_id => 1 } to /places/1/photos/1" do
    route_for(:controller => "photos", :action => "show", :id => 1, :place_id => 1).should == "/places/1/photos/1"
  end
  
  it "should map { :controller => 'photos', :action => 'edit', :id => 1, :place_id => 1 } to /places/1/photos/1;edit" do
    route_for(:controller => "photos", :action => "edit", :id => 1, :place_id => 1).should == "/places/1/photos/1;edit"
  end
  
  it "should map { :controller => 'photos', :action => 'update', :id => 1, :place_id => 1} to /places/1/photos/1" do
    route_for(:controller => "photos", :action => "update", :id => 1, :place_id => 1).should == "/places/1/photos/1"
  end
  
  it "should map { :controller => 'photos', :action => 'destroy', :id => 1, :place_id => 1} to /places/1/photos/1" do
    route_for(:controller => "photos", :action => "destroy", :id => 1, :place_id => 1).should == "/places/1/photos/1"
  end
  
end

describe PhotosController, "handling GET /photos" do

  before do
    @photo = mock_model(Photo)
    @place = mock_model(Place, :photos => [@photo])
    Place.stub!(:find).and_return(@place)
  end
  
  def do_get
    get :index, :place_id => 1
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end

  it "should render index template" do
    do_get
    response.should render_template('index')
  end
  
  it "should find all photos" do
    @place.should_receive(:photos).at_least(:once)
    do_get
  end
  
  it "should assign the found photos for the view" do
    do_get
    assigns[:photos].should == [@photo]
  end
end

describe PhotosController, "handling GET /photos.xml" do

  before do
    @photo = mock_model(Photo, :to_xml => "XML")
    @place = mock_model(Place, :photos => [@photo])
    Place.stub!(:find).and_return(@place)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :index, :place_id => 1
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end

  it "should find all photos" do
    @place.should_receive(:photos).and_return([@photo])
    do_get
  end
  
  it "should render the found photos as xml" do
    @photo.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should =~ /xml/
  end
end

describe PhotosController, "handling GET /photos/1" do

  before do
    @photo = mock_model(Photo)
    Photo.stub!(:find).and_return(@photo)
    
    @place = mock_model(Place)
    Place.stub!(:find).and_return(@place)
  end
  
  def do_get
    get :show, :id => "1", :place_id => 1
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should render show template" do
    do_get
    response.should render_template('show')
  end
  
  it "should find the photo requested" do
    Photo.should_receive(:find).with("1").and_return(@photo)
    do_get
  end
  
  it "should assign the found photo for the view" do
    do_get
    assigns[:photo].should equal(@photo)
  end
end

describe PhotosController, "handling GET /photos/1.xml" do

  before do
    @photo = mock_model(Photo, :to_xml => "XML")
    Photo.stub!(:find).and_return(@photo)
    
    @place = mock_model(Place)
    Place.stub!(:find).and_return(@place)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :show, :id => "1", :place_id => 1
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should find the photo requested" do
    Photo.should_receive(:find).with("1").and_return(@photo)
    do_get
  end
  
  it "should render the found photo as xml" do
    @photo.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

describe PhotosController, "handling GET /photos/new" do

  before do
    @photo = mock_model(Photo)
    Photo.stub!(:new).and_return(@photo)
    
    @place = mock_model(Place)
    Place.stub!(:find).and_return(@place)
  end
  
  def do_get
    get :new, :place_id => 1
  end

  it "should be successful when logged in" do
    do_login
    do_get
    response.should be_success
  end
  
  it "should redirect without login" do
    do_get
    response.should redirect_to('/session/new')
  end
  
  it "should render new template" do
    do_login
    do_get
    response.should render_template('new')
  end
  
  it "should create an new photo" do
    do_login
    Photo.should_receive(:new).and_return(@photo)
    do_get
  end
  
  it "should not save the new photo" do
    do_login
    @photo.should_not_receive(:save)
    do_get
  end
  
  it "should assign the new photo for the view" do
    do_login
    do_get
    assigns[:photo].should equal(@photo)
  end
end

describe PhotosController, "handling GET /photos/1/edit" do

  before do
    @photo = mock_model(Photo)
    Photo.stub!(:find).and_return(@photo)
    
    @place = mock_model(Place)
    Place.stub!(:find).and_return(@place)
  end
  
  def do_get
    get :edit, :id => "1", :place_id => 1
  end

  it "should be successful when logged in" do
    do_login
    do_get
    response.should be_success
  end
  
  it "should redirect without login" do
    do_get
    response.should redirect_to('/session/new')
  end
  
  it "should render edit template" do
    do_login
    do_get
    response.should render_template('edit')
  end
  
  it "should find the photo requested" do
    do_login
    Photo.should_receive(:find).and_return(@photo)
    do_get
  end
  
  it "should assign the found Photo for the view" do
    do_login
    do_get
    assigns[:photo].should equal(@photo)
  end
end

describe PhotosController, "handling POST /photos" do

  before do
    @photo = mock_model(Photo, :to_param => "1", :place_id= => nil, :user_id= => nil)
    Photo.stub!(:new).and_return(@photo)
    
    @place = mock_model(Place, :to_param => "1")
    Place.stub!(:find).and_return(@place)
  end
  
  def post_with_successful_save
    @photo.should_receive(:save).and_return(true)
    post :create, :photo => {}
  end
  
  def post_with_failed_save
    @photo.should_receive(:save).and_return(false)
    post :create, :photo => {}
  end
  
  it "should create a new photo if logged in" do
    do_login
    Photo.should_receive(:new).with({}).and_return(@photo)
    post_with_successful_save
  end

  it "should redirect without login" do
    post :create, :photo => {}
    response.should redirect_to('/session/new')
  end
  
  it "should redirect to the new photo on successful save" do
    do_login
    post_with_successful_save
    response.should redirect_to(place_path("1"))
  end

  it "should re-render 'new' on failed save" do
    do_login
    post_with_failed_save
    response.should render_template('new')
  end
end

describe PhotosController, "handling PUT /photos/1" do

  before do
    @photo = mock_model(Photo, :to_param => "1")
    Photo.stub!(:find).and_return(@photo)
    
    @place = mock_model(Place)
    Place.stub!(:find).and_return(@place)
  end
  
  def put_with_successful_update
    @photo.should_receive(:update_attributes).and_return(true)
    put :update, :id => "1", :place_id => 1
  end
  
  def put_with_failed_update
    @photo.should_receive(:update_attributes).and_return(false)
    put :update, :id => "1", :place_id => 1
  end
  
  it "should redirect without login" do
    put :update, :photo => {}
    response.should redirect_to('/session/new')
  end
  
  it "should find the photo requested if logged in" do
    do_login
    Photo.should_receive(:find).with("1").and_return(@photo)
    put_with_successful_update
  end

  it "should update the found photo" do
    do_login
    put_with_successful_update
    assigns(:photo).should equal(@photo)
  end

  it "should assign the found photo for the view" do
    do_login
    put_with_successful_update
    assigns(:photo).should equal(@photo)
  end

  it "should redirect to the photo on successful update" do
    do_login
    put_with_successful_update
    response.should redirect_to(photo_url("1"))
  end

  it "should re-render 'edit' on failed update" do
    do_login
    put_with_failed_update
    response.should render_template('edit')
  end
end

describe PhotosController, "handling DELETE /photos/1" do

  before do
    @photo = mock_model(Photo, :destroy => true)
    Photo.stub!(:find).and_return(@photo)
    
    @place = mock_model(Place)
    Place.stub!(:find).and_return(@place)
  end
  
  def do_delete
    delete :destroy, :id => "1", :place_id => 1
  end

  it "should redirect without login" do
    do_delete
    response.should redirect_to('/session/new')
  end
  
  it "should find the photo requested if logged in" do
    do_login
    Photo.should_receive(:find).with("1").and_return(@photo)
    do_delete
  end
  
  it "should call destroy on the found photo" do
    do_login
    @photo.should_receive(:destroy)
    do_delete
  end
  
  it "should redirect to the photos list" do
    do_login
    do_delete
    response.should redirect_to(photos_url)
  end
end
