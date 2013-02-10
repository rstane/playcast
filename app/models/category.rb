# coding: utf-8
class Category < ActiveRecord::Base
  attr_accessible :name

  default_scope { order( "sort ASC" ) }

  has_many :categorizes
end
