class Schedule < ActiveRecord::Base
  attr_accessible :adopt_flag, :candidate_day, :plan_id

  belongs_to :plan
end
