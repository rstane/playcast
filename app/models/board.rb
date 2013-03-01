# coding: utf-8
class Board < ActiveRecord::Base
  attr_accessible :plan_id

  # アソシエーション
  belongs_to :plan
  has_many :board_comments

  # バリデーション
  validates :plan_id, presence: true
end
