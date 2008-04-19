class PlacesController < ApplicationController
  
  @protected_actions = [ :new, :create, :edit, :update, :destroy ]
  before_filter :login_required, :only => @protected_actions
  
  protected
    def setup_google_map_for(place)
      map = GMap.new("map_div")
      map.control_init(:large_map => true,:map_type => true)
      map.center_zoom_init([place.lat,place.lng],14)
      map.overlay_init(GMarker.new([place.lat,place.lng],:title => place.title, :info_window => place.title))
      #map.event_init(map,'click',"function(overlay,point) { alert(point); }")
      return map
    end
  
  public
  
  # GET /places
  # GET /places.xml
  def index
    #@places = Place.find(:all)
    @places = Place.paginate :page => params[:page], :order => "created_at DESC"
    
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @places.to_xml }
    end
  end
  
  # POST /places;search
  include ActionView::Helpers::TextHelper
  
  def search
    @query = params[:search][:query]
    puts @query.inspect
    if @query.nil? || @query.blank?
      flash[:notice] = "You need to search for something"
      @places = Place.find(:all)
    else
      # TODO refactor this view method usage to the view!
      # TODO agh no time for proper text searching
      q = "%#{@query}%"
      @places = Place.paginate(:conditions => ["title LIKE ? or address LIKE ? or telephone LIKE ?",q,q,q], :order => "created_at DESC", :page => params[:page])
      flash[:notice] = "Found #{pluralize(@places.size,'place')}"
    end
    render :action => 'index'
  end
  
  # GET /places/1
  # GET /places/1.xml
  def show
    @place = Place.find(params[:id])
    @nearby = @place.nearby(5) # Km
    @map = setup_google_map_for(@place)
    @photos = @place.photos.delete_if { |photo| photo.thumbnail? }
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @place.to_xml }
    end
  end

  # GET /places/new
  def new
    @place = Place.new
  end

  # GET /places/1;edit
  def edit
    @place = Place.find(params[:id])
  end

  # POST /places
  # POST /places.xml
  def create
    @place = Place.new(params[:place])
    @place.user_id = current_user.id
    
    respond_to do |format|
      if @place.save
        flash[:notice] = 'Place was successfully created.'
        format.html { redirect_to place_url(@place) }
        format.xml  { head :created, :location => place_url(@place) }
      else
        flash[:notice] = 'Unable to create place.'
        format.html { render :action => "new" }
        format.xml  { render :xml => @place.errors.to_xml }
      end
    end
  end

  # PUT /places/1
  # PUT /places/1.xml
  def update
    @place = Place.find(params[:id])

    respond_to do |format|
      if @place.update_attributes(params[:place])
        flash[:notice] = 'Place was successfully updated.'
        format.html { redirect_to place_url(@place) }
        format.xml  { head :ok }
      else
        flash[:notice] = 'Unable to update place.'
        format.html { render :action => "edit" }
        format.xml  { render :xml => @place.errors.to_xml }
      end
    end
  end

  # DELETE /places/1
  # DELETE /places/1.xml
  def destroy
    @place = Place.find(params[:id])
    @place.destroy
    flash[:notice] = 'Place was sucessfully deleted.'
    respond_to do |format|
      format.html { redirect_to places_url }
      format.xml  { head :ok }
    end
  end
end
