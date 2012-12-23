class Plan < ActiveRecord::Base
  attr_accessible :budget, :description, :image_url, :max_people, :min_people, :place, :publish_end_at, :publish_start_at, :target_people, :title, :user_id

  belongs_to :user
  has_many :comments
  has_many :favorites
  has_many :entries
  has_many :categorizes
end
