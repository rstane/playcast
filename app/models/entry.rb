# coding: utf-8
class Entry < ActiveRecord::Base
  attr_accessible :plan_id, :user_id

  belongs_to :user
  belongs_to :plan
  has_many :feeds

  # コールバック
  after_create :create_feed_entry

  private

  #-------------------#
  # create_feed_entry #
  #-------------------#
  # フィード作成
  def create_feed_entry
    FeedEntry.create( entry_id: self.id, plan_id: self.plan_id, user_id: self.user_id, happen: "参加しました。" )
  end
end
