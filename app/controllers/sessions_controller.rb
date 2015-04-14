class SessionsController < ApplicationController
  
  def new
    if session[:user_id] != nil
      b = Board.find_by_user_id_and_main_board( session[:user_id], true )
      u = User.find(session[:user_id])
     redirect_to owned_board_path(u.nickname, b.id)
    else
      @user = User.new
    end
  end
  
  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      b = Board.find_by_user_id_and_main_board( user.id, true)
      session[:active_board] = b.id
      redirect_to root_url, :notice => "Logged in"
    else
      flash.now.alert = "Invalid email or password. Please try again"
      render root_url
    end
  end
    
  def destroy
    session[:user_id] = nil
    session[:active_board] = nil
    redirect_to root_url, notice => "Logged out!"
  end
end