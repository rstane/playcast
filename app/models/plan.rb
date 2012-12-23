# coding: utf-8
class Plan < ActiveRecord::Base
  attr_accessible :budget, :description, :image_url, :max_people, :min_people, :place, :publish_end_at, :publish_start_at, :target_people, :title, :user_id

  belongs_to :user
  has_many :comments
  has_many :favorites
  has_many :entries
  has_many :categorizes
  has_many :feeds

  # コールバック
  after_create :create_feed_plan_start

  private

  #------------------------#
  # create_feed_plan_start #
  #------------------------#
  # フィード作成
  def create_feed_plan_start
    FeedPlan.create( plan_id: self.id, user_id: self.user_id, happen: "参加募集が開始しました。" )
  end
end
