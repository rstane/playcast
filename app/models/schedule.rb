class Schedule < ActiveRecord::Base
  attr_accessible :adopt_flag, :candidate_day, :plan_id, :close_at

  belongs_to :plan
  has_many :participations
end
