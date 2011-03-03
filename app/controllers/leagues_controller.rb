class LeaguesController < ApplicationController
  before_filter :leagues, :only => [:index]
  before_filter :league, :only => [:new, :create, :show, :edit, :update, :destroy, :add_players_to_team]
  before_filter :organization, :only => [:new, :create, :edit]
  before_filter :check_for_organization_on_create, :only => [:create]
  before_filter :grouped_games, :only => [:show, :add_players_to_team]
  
  filter_access_to :all
  filter_access_to [:update, :edit, :destroy, :add_players_to_team], :attribute_check => true
  
  def index
    respond_to do |format|
      format.html
      format.xml  { render :xml => @leagues }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.xml  { render :xml => @league }
    end
  end
  
  def new
    respond_to do |format|
      format.html
      format.xml  { render :xml => @league }
    end
  end

  def edit
  end

  def create
    @league = League.new(params[:league])
    respond_to do |format|
      if @league.save
        flash[:notice] = 'League was successfully created.'
        format.html { redirect_to(@league) }
        format.xml  { render :xml => @league, :status => :created, :location => @league }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @league.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @league.update_attributes(params[:league])
        flash[:notice] = 'League was successfully updated.'
        format.html { redirect_to(@league) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @league.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @league.destroy
    respond_to do |format|
      format.html { redirect_to(leagues_url) }
      format.xml  { head :ok }
    end
  end
  
  # TODO move this to rostering controller
  def add_players_to_team
    team = nil
    if params[:league_teams] && params[:league_teams][:team] && params[:players]
      team = Team.find(params[:league_teams][:team])
      params[:players].each_pair do |k,v|
        player = Player.find(k)
        team.players << player
      end
    end
    
    respond_to do |format|
      if team && team.save
        flash[:notice] = 'Player(s) added to team successfully.'
        format.html { redirect_to(@league) }
        format.xml  { head :ok }
      else
        format.html { render :action => "show" }
        format.xml  { render :xml => team.errors, :status => :unprocessable_entity }
      end
    end 
  end
  
  private
    def league
      if params[:id]
        @league = League.find(params[:id])
      else
        @league = League.new
      end
      @players = @league.players.find(:all, :order => sort_order('id'))
    end
  
    def leagues
      @leagues = League.find(:all)
    end
  
    def organization
      if params[:organization_id]
        @organization = Organization.find(params[:organization_id])
        @league.organization = @organization
      elsif params[:league] && params[:league][:organization_id]
        @organization = Organization.find(params[:league][:organization_id])
        @league.organization = @organization
      else
        @organization = @league.organization
      end
    end
    
    def check_for_organization_on_create
      if params[:organization_id]
        @organization = Organization.find(params[:organization_id])
      elsif params[:league] && params[:league][:organization_id]
        @organization = Organization.find(params[:league][:organization_id])
      else
        flash[:notice] = 'League must be created under an Organization.'
        redirect_to(organizations_path)
      end
    end
    
    def grouped_games
      # TODO May want to reduce number of select
      # players and player's registrations are used in
      # the html view
      @grouped_game_sets = @league.game_sets.group_by(&:time)
      @grouped_games = @league.games.group_by(&:time)
    end
end
