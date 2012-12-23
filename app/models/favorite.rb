# coding: utf-8
class Favorite < ActiveRecord::Base
  attr_accessible :plan_id, :user_id

  belongs_to :user
  belongs_to :plan
end
