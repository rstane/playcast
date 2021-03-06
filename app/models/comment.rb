# coding: utf-8
class Comment < ActiveRecord::Base
  attr_accessible :content, :plan_id, :user_id, :board_id

  belongs_to :user
  belongs_to :plan
  has_many :feeds

  # コールバック
  after_create :create_feed_comment

  # バリデーション
  validates :content, presence: true, length: { maximum: 1000 }

  private

  # フィード作成
  def create_feed_comment
    plan = Plan.where( id: self.plan_id ).first
    FeedComment.create( comment_id: self.id, plan_id: self.plan_id, user_id: plan.user_id, happen: "コメントが投稿されました。", send_mail_flag: true )
  end
end
