# coding: utf-8
class Cheer < ActiveRecord::Base
  attr_accessible :plan_id, :user_id

  belongs_to :user
  belongs_to :plan

  # カウンターキャッシュ
  counter_culture :plan
end
