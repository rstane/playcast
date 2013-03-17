class WillEntry < ActiveRecord::Base
  attr_accessible :plan_id, :user_id
  belongs_to :plan
  belongs_to :user
end
