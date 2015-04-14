class User < ActiveRecord::Base
  attr_accessible :avatar, :email, :first_name, :last_name, :password, :password_confirmation, :nickname
  
  has_secure_password
  validates_presence_of :password, :on => :create
  validates_format_of :password, :with => /(?=.*?[a-zA-Z])(?=.*?[^a-zA-Z]).{8,}/
  validates :email, :presence => true, :uniqueness => { :case_sensitive => false } 
  validates_format_of :email, :with => /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/
  validates :nickname, :presence => true, :uniqueness => { :case_sensitive => false } 
  validates_format_of :nickname, :with => /^[a-z0-9_-]{3,16}$/  
  
  has_many :boards
  has_one :default_board, :conditions => {:main_board => true}, :class_name => 'Board' 
  
  after_create :default_board_creation
  
  def default_board_creation
    boards.build(:name => "My Stikis", :main_board => true).save
  end
  
end
