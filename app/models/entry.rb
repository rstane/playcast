# coding: utf-8
class Entry < ActiveRecord::Base
  attr_accessible :plan_id, :user_id, :schedule_id, :comment

  belongs_to :user
  belongs_to :plan
  has_many :feeds
  has_many :participations, :dependent => :destroy

  # コールバック
  after_create :create_feed_entry

  # バリデーション
  validates :comment, presence: true, length: { maximum: 1000 }

  private

  #-------------------#
  # create_feed_entry #
  #-------------------#
  # フィード作成
  def create_feed_entry
    plan = Plan.where( id: self.plan_id ).first
    FeedEntry.create( entry_id: self.id, plan_id: self.plan_id, user_id: plan.user_id, happen: "参加しました。" )
  end
end
