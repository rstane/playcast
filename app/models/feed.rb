# coding: utf-8
class Feed < ActiveRecord::Base
  attr_accessible :comment_id, :entry_id, :happen, :plan_id, :type, :user_id, :mail_sent_at

  belongs_to :comment
  belongs_to :entry
  belongs_to :plan
  belongs_to :user

  private

  #----------------------#
  # self.send_mail_batch #
  #----------------------#
  # メール送信バッチ処理
  #  ruby script/rails runner "Feed.send_mail_batch"
  def self.send_mail_batch
#    plan_feeds = FeedPlan.where( mail_sent_at: nil ).includes( :plan, :user ).all
    plan_feeds = FeedPlan.where( mail_sent_at: nil ).includes( :plan, :user ).limit(100).all
    puts "[ ---------- plan_feeds.length ---------- ]" ; plan_feeds.length.tapp ;

    plan_feeds.each{ |feed|
      if feed.user.present?
        result = UserMailer.plan_feed( feed.plan, feed, feed.user ).deliver
        feed.update_attributes( mail_sent_at: Time.now ) if result.present?
      end
    }
  end
end
