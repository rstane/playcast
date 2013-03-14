# coding: utf-8
class Feed < ActiveRecord::Base
  attr_accessible :comment_id, :entry_id, :happen, :plan_id, :type, :user_id, :mail_sent_at, :send_mail_flag, :sentence

  belongs_to :comment
  belongs_to :entry
  belongs_to :plan
  belongs_to :user

  # フィード文生成
  def generate_sentence
    case self.type
    when "FeedPlan"
      "「#{self.plan.title}」の#{self.happen}"
    when "FeedEntry"
      "「#{self.plan.title}」に「#{self.entry.user.name}」さんが#{self.happen}"
    when "FeedComment"
      "「#{self.plan.title}」に「#{self.comment.user.name}」さんから#{self.happen}"
    end
  end

  private

  # メール送信バッチ処理
  #  ruby script/rails runner "Feed.send_mail_batch"
  def self.send_mail_batch
    plan_feeds = Feed.where( send_mail_flag: true, mail_sent_at: nil ).includes( :plan, :user )
    puts "[ ---------- plan_feeds.length ---------- ]" ; plan_feeds.length.tapp ;

    plan_feeds.find_each{ |feed|
      if feed.user.present?
        begin
          result = UserMailer.plan_feed( feed.plan, feed, feed.user ).deliver
          puts "[ ---------- result user:#{feed.user.id} ---------- ]" ; result.tapp ;
          feed.update_attributes( mail_sent_at: Time.now ) if result.present?
        rescue Exception => e
          puts "[ ---------- send_mail_batch Exception ---------- ]" ; e.tapp ;
        end
      end
    }
  end

  # feed.sentence更新用バッチ
  #  ruby script/rails runner "Feed.update_sentence"
  def self.update_sentence
    feeds = Feed.where( sentence: nil ).includes( :plan, :entry, :comment ).where( "plans.id IS NOT NULL AND entries.id IS NOT NULL AND comments.id IS NOT NULL" )
    feeds.each { |feed|
      feed.update_attributes( sentence: feed.generate_sentence )
    }
  end
end
