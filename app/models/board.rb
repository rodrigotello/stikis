class Board < ActiveRecord::Base
  attr_accessible :name, :user_id, :main_board
  
  validates_presence_of :name, :on => :create
  belongs_to :user
  has_many :stickers
  
  after_create :set_permissions
  
  def set_permissions
    Permission.create(:board_id => self.id, :user_id => self.user_id )
  end
  
  
end
