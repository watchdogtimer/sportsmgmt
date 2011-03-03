class PaymentsController < ApplicationController
  before_filter :require_user
  before_filter :require_admin, :except => [:new, :create, :edit, :update, :paypal_redirect]
  
  before_filter :payments, :only => [:index]
  before_filter :payment, :only => [:show, :new, :edit, :update, :destroy, :paypal_redirect]

  # access:
  # for index & show: only org admins can see their org payments
  #                   only league admins can see their league payments
  #            
  # for new & edit & update & paypal_redirect: admins or owners
  #
  # for create: any user, does registration need to belong to user?
  #
  # for destroy: superadmin
  #
  #filter_access_to :all
  #filter_access_to [:destroy], :attribute_check => true
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @payments }
    end
  end

  # GET /payments/1
  # GET /payments/1.xml
  def show
    unless current_user.admin? || current_user == @payment.registration.player
        store_location
        flash[:notice] = "You do not have access to this page"
        redirect_to new_user_session_url
        return false
    end
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @payment }
    end
  end

  # GET /payments/new
  # GET /payments/new.xml
  def new
    if params[:registration_id]
      @registration = Registration.find(params[:registration_id])
    end
    respond_to do |format|
      format.html {
        #if @registration.payment
        #  flash[:notice] = "You are already sent a payment for #{@registration.league.name}."
        #  redirect_to(player_url(current_user))
        #end
      }
      format.xml  { render :xml => @payment }
    end
  end

  # GET /payments/1/edit
  def edit
    @registration = @payment.registration
    unless current_user.admin? || current_user == @payment.registration.player
        store_location
        flash[:notice] = "You do not have access to this page"
        redirect_to new_user_session_url
        return false
    end
  end

  def paypal_redirect
  end
  
  # POST /payments
  # POST /payments.xml
  def create
    @payment = Payment.new(params[:payment])
    @payment.status = Payment::STATUS[0]
    if params[:registration] && params[:registration][:id]
      @registration = Registration.find(params[:registration][:id])
      @payment.registration = @registration
    end
    respond_to do |format|
      if @payment.save
        flash[:notice] = 'Payment type was saved.'
        format.html { 
          if current_user
            if @payment.payment_type == "paypal"
              redirect_to(paypal_redirect_payment_path(@payment))
            else
              redirect_to(player_path(current_user))
            end
          else
            flash[:notice] = "Not logged in."
            redirect_to(home_path)
          end
        }
        format.xml  { render :xml => @payment, :status => :created, :location => @payment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @payment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /payments/1
  # PUT /payments/1.xml
  def update
    respond_to do |format|
      if params[:payment][:status]
        @registration.update_attributes(params[:payment])
        format.html {
          redirect_to player_path(params[:player][:id])
        }
      elsif @payment.update_attributes(params[:payment])
        format.html {
          if current_user
            if @payment.payment_type == "paypal"
              redirect_to(paypal_redirect_payment_path(@payment))
            else
              redirect_to(player_path(current_user))
            end
          else
            flash[:notice] = "Not logged in."
            redirect_to(home_path)
          end
        }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @payment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /payments/1
  # DELETE /payments/1.xml
  def destroy
    @payment.destroy

    respond_to do |format|
      format.html { redirect_to(payments_url) }
      format.xml  { head :ok }
    end
  end
  
  protected
    def payments  
      @payments = Payment.all
    end
    
    def payment
      if params[:registration_id]
        #reg = Registration.find(params[:registration_id])
        #if reg.payment.payment_type && reg.payment.status
        #  @payment = Registration.find(params[:registration_id]).payment
        #else
          @payment = Payment.new(nil, nil)
        #end
      else
        @payment = Payment.new(nil, nil)
      end
    end
end
