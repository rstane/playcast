# coding: utf-8
class Comment < ActiveRecord::Base
  attr_accessible :content, :plan_id, :user_id

  belongs_to :user
  belongs_to :plan
  has_many :feeds

  # コールバック
  after_create :create_feed_comment

  private

  #---------------------#
  # create_feed_comment #
  #---------------------#
  # フィード作成
  def create_feed_comment
    FeedComment.create( comment_id: self.id, plan_id: self.plan_id, user_id: self.user_id, happen: "コメントが投稿されました。" )
  end
end
