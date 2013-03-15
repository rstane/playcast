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

  # フィード作成
  def create_feed_entry
    plan = Plan.where( id: self.plan_id ).first

    # プラン投稿者以外の参加／プラン投稿者へのフィード
    unless self.user_id == plan.user_id
      FeedEntry.create( entry_id: self.id, plan_id: self.plan_id, user_id: plan.user_id, happen: "参加しました。", send_mail_flag: true )
    end
  end
end
