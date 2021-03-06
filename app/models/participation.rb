class Participation < ActiveRecord::Base
  attr_accessible :plan_id, :schedule_id, :user_id, :entry_id

  belongs_to :user
  belongs_to :entry
  belongs_to :plan
  belongs_to :schedule
end
