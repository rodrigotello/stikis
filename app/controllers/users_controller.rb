class UsersController < ApplicationController
  
  before_filter :check_auth, :except => [:new, :create]
  before_filter :check_ownership, :only => [:edit, :update, :destroy]
  
  def check_auth
    if session[:user_id] == nil
      redirect_to root_url
    end
  end
  
  def check_ownership
    if session[:user_id] != :current_user
      b = Board.find(:user_id => self.id, :main_board => true)
      redirect_to b
    end
  end
  
  def show
    begin
      @user = User.find_by_nickname(params[:nickname])
    rescue
      redirect_to root_url
    end
    
    if @user != nil
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @user }
      end
    end
  end
  
  def edit
  end
  
  def update
  end
  
  def destroy
  end
  
  def index
  end
  
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
    @user = User.new(params[:user])
    if @user.save
      session[:user_id] = @user.id
      redirect_to user_profile_path(@user.nickname), :notice => "You have registered successfully."
    else
      render "new"
    end
  end
  
  
end
