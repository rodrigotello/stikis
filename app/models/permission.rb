class Permission < ActiveRecord::Base
  attr_accessible :board_id, :user_id
end
