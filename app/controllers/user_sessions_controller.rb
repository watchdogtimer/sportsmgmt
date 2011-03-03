# app/controllers/user_sessions_controller.rb
class UserSessionsController < ApplicationController
  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      redirect_back_or_default player_url(current_user)#maybe change this when more than just players are in the system
    else
      flash[:notice] = 'Problem logging in.'
      render :action => :new
    end
  end

  def destroy
    current_user_session.destroy
    redirect_to root_url
  end
end
