class GameSetsController < ApplicationController
  before_filter :require_admin
  before_filter :game_sets, :only => [:index]
  before_filter :game_set, :only => [:show, :new, :edit, :update, :destroy]
  before_filter :league, :only => [:show, :new, :edit, :update, :destroy]
  before_filter :team, :only => [:show, :new, :edit, :update, :destroy]

  def index
    respond_to do |format|
      format.html
      format.xml  { render :xml => @game_sets }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.xml  { render :xml => @game_set }
    end
  end
  
  def new
    respond_to do |format|
      format.html
      format.xml  { render :xml => @game_set }
    end
  end

  def edit
  end

  def create
    @game_set = GameSet.new(params[:game_set])
    respond_to do |format|
      if @game_set.save
        flash[:notice] = 'GameSet was successfully created.'
        format.html { redirect_to(smart_url) }
        format.xml  { render :xml => @game_set, :status => :created, :location => @game_set }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @game_set.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @game_set.update_attributes(params[:game_set])
        flash[:notice] = 'GameSet was successfully updated.'
        format.html { redirect_to(@game_set) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @game_set.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @game_set.destroy
    respond_to do |format|
      format.html { redirect_to(smart_delete_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  def league
    if params[:league_id]
      @league = League.find(params[:league_id])
    elsif params[:team_id]
      @league = Team.find(params[:team_id]).league
    end
  end
  
  def team
    if params[:team_id]
      @team = Team.find(params[:team_id])
    else
      @team = @game_set.team
    end
  end
  
  def game_sets
    if params[:league_id]
      @game_sets = League.find(params[:league_id]).game_sets
    else
      @game_sets = GameSet.find(:all)
    end
  end
  
  def game_set
    if params[:id]
      @game_set = GameSet.find(params[:id])
    else
      @game_set = GameSet.new
    end
  end
  
  def smart_url
    if @team
      team_game_set_path(@team, @game_set)
    elsif @league
      league_game_set_path(@league, @game_set)
    else
      @game_set
    end
  end
    
  def smart_delete_url
    if @league
      league_game_sets_path(@league)
    else
      game_sets_path
    end
  end
end
