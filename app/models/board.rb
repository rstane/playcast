# coding: utf-8
class Board < ActiveRecord::Base
  attr_accessible :plan_id

  belongs_to :plan
  has_many :board_comments
end
