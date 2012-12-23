# coding: utf-8
class Categorize < ActiveRecord::Base
  attr_accessible :category_id, :plan_id

  belongs_to :category
  belongs_to :plan
end
