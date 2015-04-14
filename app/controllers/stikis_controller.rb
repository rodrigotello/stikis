class StikisController < ApplicationController
  
  before_filter :prevent_hack, :only => [:create, :update, :delete]
  before_filter :check_permission, :only => [:create, :update, :delete]
  before_filter :check_ownership, :only => [:update, :delete]
  
  def prevent_hack
    if Integer(params[:user_id]) != session[:user_id] || Integer(params[:board_id]) != session[:active_board]
      b = Board.find(session[:active_board])
      #todo: Blacklist table and counter for 2 warnings
      redirect_to b, notice: "Check hack failed" #"Oh no... Please don't modify the source before submitting a stiki. This is considered a hacking attempt. You will receive a warning. Another attempt will get you blacklisted."
    end
  end
  
  def check_permission
    p = Permission.where(:user_id => Integer(params[:user_id]), :board_id => [:board_id])
    if p == nil
      #todo: Blacklist table and counter for 2 warnings
      redirect_to b, notice: "Check permission failed" #"Oh no... Please don't modify the source before submitting a stiki. This is considered a hacking attempt. You will receive a warning. Another attempt will get you blacklisted."
    end
  end
  
  def check_ownership
    s = Stiki.find_by_id_and_user_id(Integer(params[:id]), Integer(params[:user_id]) )
    if s == nil     
      redirect_to b, notice: "Check ownership failed" #"Oh no... Please don't modify the source before submitting a stiki. This is considered a hacking attempt. You will receive a warning. Another attempt will get you blacklisted."
    end
  end
  
  
  # GET /stikis
  # GET /stikis.json
  def index
    @stikis = Stiki.where(:board_id => session[:active_board])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @stikis }
    end
  end

  # GET /stikis/1
  # GET /stikis/1.json
  def show
    @stiki = Stiki.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @stiki }
    end
  end

  # GET /stikis/new
  # GET /stikis/new.json
  def new
    @stiki = Stiki.new
    b = Board.find(session[:active_board])
    respond_to do |format|
      format.html {redirect_to b}
      format.json { render json: @stiki }
    end
  end

  # GET /stikis/1/edit
  def edit
    @stiki = Stiki.find(params[:id])
  end

  # POST /stikis
  # POST /stikis.json
  def create
    @stiki = Stiki.new(params[:stiki])
    @stiki.content = params[:content]
    @stiki.positionx = params[:positionx]
    @stiki.positiony = params[:positiony]
    @stiki.color = params[:color]
    @stiki.area = params[:area]
    @stiki.board_id = params[:board_id]
    @stiki.user_id = params[:user_id]

    respond_to do |format|
      if @stiki.save
        format.html { redirect_to @stiki, notice: 'Stiki was successfully created.' }
        format.json { render json: @stiki.to_json, status: :created, location: @stiki }
      else
        format.html { render action: "new" }
        format.json { render json: @stiki.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /stikis/1
  # PUT /stikis/1.json
  def update
    @stiki = Stiki.find(params[:id])
    if params[:content] != nil 
      @stiki.content = params[:content]
    end
    if params[:positionx] != nil 
      @stiki.positionx = params[:positionx] 
    end
    if params[:positiony] != nil 
      @stiki.positiony = params[:positiony]
    end
    if params[:color] != nil 
      @stiki.color = params[:color]
    end
    if params[:area] != nil 
      @stiki.area = params[:area]
    end
    
    respond_to do |format|
      if @stiki.update_attributes(params[:stiki])
        format.html { render json: @stiki }
        format.json { render json: @stiki }
      else
        format.html { render action: "edit" }
        format.json { render json: @stiki.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stikis/1
  # DELETE /stikis/1.json
  def destroy
    @stiki = Stiki.find(params[:id])
    @stiki.destroy
    message = { :notice => "Stiki #{@stiki.id} deleted." }.to_json

    respond_to do |format|
      format.html { render json: message }
      format.json { render json: message }
    end
  end
end
