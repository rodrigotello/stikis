class ApplicationController < ActionController::Base
  protect_from_forgery
  # force_ssl
  
  before_filter :set_body_class
  
  private
  
  def logged_in?
     !!current_user
  end
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def default_board
    if session[:user_id]
      @default_board = Board.where(:main_board => true, :user_id => session[:user_id])
    end
  end
  
  def set_body_class
     add_body_class "page "
   end
  
  def stiki_color(color)
    colors = available_colors
    @stiki_color = colors[color]
  end
  
  def available_colors
    @available_colors = ['f4eb9c', 'cee29d', 'b3dde9', 'e7e7e9', 'fdfce8', 'f8deeb']
  end
  
  def stiki_area(area)
    sizes = available_sizes
    @stiki_area = sizes[area]
  end
  
  def available_sizes
    @available_sizes = ['sml', 'mid', 'lrg']
  end
  
  def add_body_class(new_class)
    @body_class ||= ""
    @body_class << "#{new_class}"
  end
  
  helper_method :current_user, :add_body_class, :stiki_color, :available_colors, :available_sizes, :stiki_area, :logged_in?

end
