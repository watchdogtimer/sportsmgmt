class OrganizationsController < ApplicationController    
  before_filter :users, :only => [:new, :edit]
  before_filter :organization, :only => [:new, :show, :edit, :update, :destroy]
  before_filter :organizations, :only => [:index]
  filter_access_to :all
  filter_access_to [:show, :update, :edit, :destroy], :attribute_check => true
  
  def index
    respond_to do |format|
      format.html
      format.xml  { render :xml => @organizations }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.xml  { render :xml => @organization }
    end
  end

  def new
    respond_to do |format|
      format.html
      format.xml  { render :xml => @organization }
    end
  end

  def edit
  end

  def create
    @organization = Organization.new(params[:organization])
    respond_to do |format|
      if @organization.save
        flash[:notice] = 'Organization was successfully created.'
        format.html { redirect_to(@organization) }
        format.xml  { render :xml => @organization, :status => :created, :location => @organization }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @organization.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @organization.update_attributes(params[:organization])
        flash[:notice] = 'Organization was successfully updated.'
        format.html { redirect_to(@organization) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @organization.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @organization.destroy
    respond_to do |format|
      format.html { redirect_to(organizations_url) }
      format.xml  { head :ok }
    end
  end
  
  private
    def users
      @users = User.all
    end
    
    def organization
      if params[:id]
        @organization = Organization.find(params[:id])
      else
        @organization = Organization.new
      end
    end
    
    def organizations
      @organizations = Organization.all
    end
end
