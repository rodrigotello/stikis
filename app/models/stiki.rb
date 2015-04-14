class Stiki < ActiveRecord::Base
  attr_accessible :area, :board_id, :color, :content, :positionx, :positiony, :user_id
  
  #validates_presence_of :board_id, :on => :create 
  belongs_to :board
  
end
