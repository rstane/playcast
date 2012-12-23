# coding: utf-8
class Feed < ActiveRecord::Base
  attr_accessible :comment_id, :entry_id, :happen, :plan_id, :type, :user_id

  belongs_to :comment
  belongs_to :entry
  belongs_to :plan
  belongs_to :user
end
