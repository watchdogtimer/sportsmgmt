class LeagueItemsController < ApplicationController
  before_filter :require_admin
  # GET /league_items
  # GET /league_items.xml
  def index
    @league_items = LeagueItem.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @league_items }
    end
  end

  # GET /league_items/1
  # GET /league_items/1.xml
  def show
    @league_item = LeagueItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @league_item }
    end
  end

  # GET /league_items/new
  # GET /league_items/new.xml
  def new
    @league_item = LeagueItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @league_item }
    end
  end

  # GET /league_items/1/edit
  def edit
    @league_item = LeagueItem.find(params[:id])
  end

  # POST /league_items
  # POST /league_items.xml
  def create
    @league_item = LeagueItem.new(params[:league_item])

    respond_to do |format|
      if @league_item.save
        flash[:notice] = 'LeagueItem was successfully created.'
        format.html { redirect_to(@league_item) }
        format.xml  { render :xml => @league_item, :status => :created, :location => @league_item }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @league_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /league_items/1
  # PUT /league_items/1.xml
  def update
    @league_item = LeagueItem.find(params[:id])

    respond_to do |format|
      if @league_item.update_attributes(params[:league_item])
        flash[:notice] = 'LeagueItem was successfully updated.'
        format.html { redirect_to(@league_item) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @league_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /league_items/1
  # DELETE /league_items/1.xml
  def destroy
    @league_item = LeagueItem.find(params[:id])
    @league_item.destroy

    respond_to do |format|
      format.html { redirect_to(league_items_url) }
      format.xml  { head :ok }
    end
  end
end
