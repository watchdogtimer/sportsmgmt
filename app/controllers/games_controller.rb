class GamesController < ApplicationController
  before_filter :require_admin
  before_filter :games, :only => [:index]
  before_filter :team, :except => :index
  before_filter :game, :except => [:index, :create]
  before_filter :game_set, :except => :index
  before_filter :league, :except => :index #must be after :game before_filter
  before_filter :teams, :only => [:new, :edit] # must be after :game, :game_set, and :league

  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @games }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @game }
    end
  end

  def new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @game }
    end
  end

  def edit
  end

  def create
    @game = Game.new(params[:game])
    respond_to do |format|
      if @game.save
        flash[:notice] = 'Game was successfully created.'
        format.html { redirect_to(smart_url) }
        format.xml  { render :xml => @game, :status => :created, :location => @game }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @game.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @game.update_attributes(params[:game])
        flash[:notice] = 'Game was successfully updated.'
        format.html { redirect_to(smart_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @game.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @game.destroy
    respond_to do |format|
      format.html { redirect_to(smart_destroy_url) }
      format.xml  { head :ok }
    end
  end
  
  private
    def teams
      if @league
        @teams = @league.teams
      else        
        @teams = Team.find(:all)
      end
    end
    
    def team
      @team = nil
      if params[:team_id]
        @team = Team.find(params[:team_id])
      elsif params[:game] && params[:game][:team_id]
        @team = Team.find(params[:game][:team_id])
      elsif @game && @game.team
        @team = @game.team
      end
    end
    
    def league
      @league = nil
      if params[:league_id]
        @league = League.find(params[:league_id])
      elsif params[:game_set_id]
        @league = GameSet.find(params[:game_set_id]).league
      elsif @team
        @league = @team.league
      elsif @game
        @league = @game.league
      end
    end
    
    def game_set
      @game_set = nil
      @game_set = GameSet.find(params[:game_set_id]) if params[:game_set_id]
    end
    
    def game
      if params[:id]
        @game = Game.find(params[:id])
      else
        @game = Game.new
        if params[:team_id]
          @game.team = Team.find(params[:team_id])
        end
      end
    end
    
    def games
      @games = params[:league_id] ? League.find([:league_id]).games : Game.find(:all)
    end
    
    def smart_url
      if @game_set
        game_set_game_path(@game_set, @game)
      elsif @team
        team_game_path(@team, @game)
      elsif @league
        league_game_path(@league, @game)
      else
        @game
      end
    end
    
    def smart_delete_url
      if @game_set
        game_set_games_path(@game_set)
      elsif @team
        team_games_path(@team)
      elsif @league
        league_games_path(@league)
      else
        games_path
      end
    end
end
