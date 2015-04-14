class BoardsController < ApplicationController
  
  before_filter :check_auth
  before_filter :check_permissions, :except => [:new, :create, :index]
  
  def check_auth
    if session[:user_id] == nil
      redirect_to root_url
    end
  end
  
  def check_permissions
    p = Permission.where( :user_id => session[:user_id], :board_id => params[:id])
    if p == nil
      @message = "You can not acces this board."
      if self.default == false
        @message ="#{@message} If you would like to access it, contact #{User.find(self.user_id).email} to request permission."
      end
      b = Board.where(:user_id => session[:user_id], :main_board => true)
      redirect_to b, :notice => @message
    end
  end
  
  # GET /boards
  # GET /boards.json
  def index
    user = User.find_by_nickname(params[:nickname])
    @boards = Board.find_all_by_user_id(user.id)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @boards }
    end
  end

  # GET /boards/1
  # GET /boards/1.json
  def show
    user = User.find_by_nickname(params[:nickname])
    @board = Board.find_by_user_id_and_id( user.id, params[:board_id] )
    @stikis = Stiki.where(:board_id => @board.id)
    session[:active_board] = Integer(params[:board_id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @board }
    end
  end

  # GET /boards/new
  # GET /boards/new.json
  def new
    @board = Board.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @board }
    end
  end

  # GET /boards/1/edit
  def edit
    @board = Board.find(params[:id])
  end

  # POST /boards
  # POST /boards.json
  def create
    @board = Board.new(params[:board])

    respond_to do |format|
      if @board.save
        format.html { redirect_to @board, notice: 'Board was successfully created.' }
        format.json { render json: @board, status: :created, location: @board }
      else
        format.html { render action: "new" }
        format.json { render json: @board.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /boards/1
  # PUT /boards/1.json
  def update
    @board = Board.find(params[:id])

    respond_to do |format|
      if @board.update_attributes(params[:board])
        format.html { redirect_to @board, notice: 'Board was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @board.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /boards/1
  # DELETE /boards/1.json
  def destroy
    @board = Board.find(params[:id])
    @board.destroy

    respond_to do |format|
      format.html { redirect_to boards_url }
      format.json { head :no_content }
    end
  end
end
