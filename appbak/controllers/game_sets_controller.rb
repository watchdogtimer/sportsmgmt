class GameSetsController < ApplicationController
  # GET /game_sets
  # GET /game_sets.xml
  def index
    @game_sets = GameSet.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @game_sets }
    end
  end

  # GET /game_sets/1
  # GET /game_sets/1.xml
  def show
    @game_set = GameSet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @game_set }
    end
  end

  # GET /game_sets/new
  # GET /game_sets/new.xml
  def new
    @game_set = GameSet.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @game_set }
    end
  end

  # GET /game_sets/1/edit
  def edit
    @game_set = GameSet.find(params[:id])
  end

  # POST /game_sets
  # POST /game_sets.xml
  def create
    @game_set = GameSet.new(params[:game_set])

    respond_to do |format|
      if @game_set.save
        format.html { redirect_to(@game_set, :notice => 'Game set was successfully created.') }
        format.xml  { render :xml => @game_set, :status => :created, :location => @game_set }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @game_set.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /game_sets/1
  # PUT /game_sets/1.xml
  def update
    @game_set = GameSet.find(params[:id])

    respond_to do |format|
      if @game_set.update_attributes(params[:game_set])
        format.html { redirect_to(@game_set, :notice => 'Game set was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @game_set.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /game_sets/1
  # DELETE /game_sets/1.xml
  def destroy
    @game_set = GameSet.find(params[:id])
    @game_set.destroy

    respond_to do |format|
      format.html { redirect_to(game_sets_url) }
      format.xml  { head :ok }
    end
  end
end
