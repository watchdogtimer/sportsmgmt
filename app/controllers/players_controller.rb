class PlayersController < ApplicationController
  #before_filter :require_user, :except => [:new, :create, :edit]
  before_filter :require_admin, :only => [:index, :destroy]
  before_filter :players, :only => [:index]
  before_filter :player, :only => [:show, :edit, :update, :destroy]
  before_filter :league, :only => [:new, :create] # must happen before already_registered call
  before_filter :already_registered, :only => [:new]
  before_filter :skills, :only => [:new, :create]
  
  filter_access_to [:index, :show, :edit, :update, :destroy], :attribute_check => true
  
  def index
    respond_to do |format|
      format.html
      format.xml  { render :xml => @players }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.xml  { render :xml => @player }
    end
  end

  def new
    @player = Player.new
    respond_to do |format|
      format.html
      format.xml  { render :xml => @player }
    end
  end

  def edit
  end

  def create
    @player = Player.new(params[:player])
    respond_to do |format|
      if @player.save
        flash[:notice] = 'You have successfully created your account.'
        # this is the only thing that deviates from a resourceful controller
        # does this warrant a separate controller for registering players??
        # b/c I plan to move to resourceful_controller
        format.html { redirect_to(smart_url) }
        format.xml  { render :xml => @player, :status => :created, :location => @player }
      else
        format.html { render :action => 'new' }
        format.xml  { render :xml => @player.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @player.update_attributes(params[:player])
        flash[:notice] = 'Info was updated successfully.'
        format.html { redirect_to(@player) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @player.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @player.destroy
    respond_to do |format|
      format.html { redirect_to(players_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def players
    if params[:league_id]
      @league = League.find(params[:league_id])
      @players = @league.players
    else
      @players = Player.find(:all)
    end
  end
  
  def player
    @player = Player.find(params[:id], :include => [:teams, :ability, :throw_level, :registrations])
    #require_owner(@player)
  end
  
  def league
    if params[:league_id]
      @league = League.find(params[:league_id])
    end
  end
  
  def already_registered
    return unless current_user
    if !current_user.admin?
      if current_user.is_registered_for?(@league)
        flash[:notice] = "You are already registered for #{@league.name}."
      else
        flash[:notice] = "You cannot create a new account while logged in."
      end
      redirect_to(player_url(current_user))
    end
  end
  
  def skills
    @abilities = Ability.find(:all)
    @throw_levels = ThrowLevel.find(:all)
  end
  
  def smart_url
    if params[:league_id]
      new_league_registration_path(params[:league_id])
    else
      player_path(@player)
    end
  end
end
