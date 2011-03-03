class TeamsController < ApplicationController
  before_filter :player, :only => [:index, :update]
  before_filter :league, :only => [:index, :show, :new, :edit, :update, :create]
  before_filter :players, :only => [:index, :edit] # must happen after league to scope players
  before_filter :teams, :only => [:index] # must happen after player and league before_filters
  before_filter :team, :only => [:show, :new, :edit, :update, :destroy]
  before_filter :remove_organizer, :only => [:update]
  before_filter :remove_players, :only => [:update]
  
  filter_access_to :all
  filter_access_to [:new, :show, :update, :edit, :destroy], :attribute_check => true
  
  def index
    respond_to do |format|
      format.html
      format.xml  { render :xml => @teams }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.xml  { render :xml => @team }
    end
  end
  
  def new
    respond_to do |format|
      format.html
      format.xml  { render :xml => @team }
    end
  end
  
  def edit
  end
  
  def create
    @team = Team.new(params[:team])
    respond_to do |format|
      if @team.save
        flash[:notice] = 'Team was successfully created.'
        format.html { redirect_to(smart_url) }
        format.xml  { render :xml => @team, :status => :created, :location => @team }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @team.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @team.update_attributes(params[:team])
        flash[:notice] = 'Team was successfully updated.'
        format.html { redirect_to(smart_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @team.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @team.destroy
    respond_to do |format|
      format.html { redirect_to(teams_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def league
    @league = League.find(params[:league_id]) if params[:league_id]
  end
  
  def player
    @player = Player.find(params[:player_id]) if params[:player_id]
  end
  
  def players
    @players = Player.find(:all)
    @players = @league.players if @league
  end
  
  def team
    if params[:id]
      @team = Team.find(params[:id])
    else
      @team = Team.new
    end
  end
  
  # TODO make this full-blown action with respond_to block
  def remove_organizer
    if params[:remove_organizer]
      @team.organizer = nil
      @team.save
    end
  end
  
  # TODO make this full-blown action with respond_to block
  def remove_players
    if params[:players]
      params[:players].each_pair do |k,v|
        player = Player.find(k)
        @team.players.delete(player)
      end
      @team.save
    end
  end
  
  def smart_url
    if @league
      league_team_path(@league, @team)
    else
      @team
    end
  end
  
  def teams
    if params[:league_id]
      league = League.find(params[:league_id])
      @teams = league.teams
    elsif params[:player_id]
      player = Player.find(params[:player_id])     
      @teams = player.teams
    else
      @teams = Team.find(:all)
    end
  end
  
  #def require_player
  #  unless current_user.admin?
  #    if params[:id]
  #      team = Team.find(params[:id])
  #      require_player_for(team.league)
  #    elsif params[:league_id]
  #      league = League.find(params[:league_id])
  #      require_player_for(league)
  #    elsif params[:player_id]
  #      player = Player.find(params[:player_id])      
  #      require_owner(player)
  #    else
  #      require_admin
  #    end
  #  end
  #end
end
