class Comment < ActiveRecord::Base
  attr_accessible :content, :plan_id, :user_id

  belongs_to :user
  belongs_to :plan
end
