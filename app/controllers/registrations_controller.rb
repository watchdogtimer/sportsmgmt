class RegistrationsController < ApplicationController
  #before_filter :require_user, :only => [:new, :create]
  #before_filter :require_admin, :except => [:new, :create]
  
  before_filter :registrations, :only => [:index]
  before_filter :registration, :only => [:show, :edit, :update, :destroy, :paypal_redirect]
  before_filter :league, :only => [:new, :edit]
  before_filter :check_already_regsitered, :only => [:new]
  before_filter :player, :only => [:destroy]
  
  def index
    respond_to do |format|
      format.html
      format.xml  { render :xml => @registrations }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.xml  { render :xml => @registration }
    end
  end

  def new
    @registration = Registration.new
    respond_to do |format|
      format.html
      format.xml  { render :xml => @registration }
    end
  end

  def edit
  end

  def create
    @registration = Registration.new(params[:registration])
    respond_to do |format|
      if @registration.save
        flash[:notice] = 'Congrats, you are registered.'
        format.html { redirect_to(smart_url) }
        format.xml  { render :xml => @registration, :status => :created, :location => @registration }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @registration.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @registration.update_attributes(params[:registration])
        flash[:notice] = 'Registration was successfully updated.'
        format.html { redirect_to(player_path(@registration.player)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @registration.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @registration.destroy
    respond_to do |format|
      format.html { redirect_to(smart_url) }
      format.xml  { head :ok }
    end
  end
  
  def paypal_redirect
  end
  
  private
  def smart_url
    path = player_path(current_user)
    if self.action_name == "create"
      if @registration.payment_type == "paypal"
        path = paypal_redirect_registration_path(@registration)
      elsif @registration.payment_type == "check"
        path = player_path(@registration.player)
      end
    elsif self.action_name == "destory"
      path = player_path(@player)
    end
    path
  end
  
  def registrations
    @registrations = Registration.all
  end
  
  def registration
    if params[:regsitration_id]
      @registration = Registration.find(params[:registration_id])
    elsif params[:id]
      @registration = Registration.find(params[:id])
    end
  end
  
  def league
    if params[:league_id]
      @league = League.find(params[:league_id])
    else
      @league = @registration.league
    end
  end
  
  def check_already_regsitered
    if current_user && !current_user.admin? && current_user.registrations.collect { |r| r.league }.include?(@league)
      flash[:notice] = "You are already registered for #{@league.name}."
      redirect_to(player_url(current_user))
    end
  end
  
  def player
    @player = @registration.player
  end
end
