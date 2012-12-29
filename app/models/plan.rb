# coding: utf-8
class Plan < ActiveRecord::Base
  attr_accessible :budget, :description, :image_url, :max_people, :min_people, :place, :publish_end_at, :publish_start_at, :target_people, :title, :user_id, :cheers_count, :favorites_count

  belongs_to :user
  has_many :comments,       :dependent => :destroy
  has_many :favorites,      :dependent => :destroy
  has_many :cheers,         :dependent => :destroy
  has_many :entries,        :dependent => :destroy
  has_many :categorizes,    :dependent => :destroy
  has_many :feeds,          :dependent => :destroy
  has_many :schedules,      :dependent => :destroy
  has_many :participations, :dependent => :destroy

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

  #---------------------------#
  # self.max_min_people_check #
  #---------------------------#
  def self.max_min_people_check( plan_id )
    plan = Plan.where( id: plan_id ).includes( :schedules ).first

    entry_count = Participation.where( plan_id: plan.id ).group( "schedule_id" ).count.sort{ |a, b| b[1].to_i <=> a[1].to_i }
    max_count = (entry_count.present? ? entry_count.first[1] : 0)

    if max_count >= plan.max_people.to_i
      # 募集終了
      plan.entry_close_flag = true
    else
      # 募集再開
      plan.entry_close_flag = false
    end

    if max_count >= plan.min_people.to_i
      # 開催決定
      plan.decide_flag = true
      schedule_ids = entry_count.select{ |x| x[1] >= max_count }.map{ |x| x[0] }
      Schedule.where( plan_id: plan.id, id: schedule_ids ).update_all( adopt_flag: true )

      # 開催決定フィード作成
      FeedPlan.where( plan_id: plan.id, happen: "開催決定が取り消されました。" ).delete_all
      Entry.where( plan_id: plan.id ).all.each{ |e|
        FeedPlan.where( plan_id: e.plan_id, user_id: e.user_id, happen: "開催が決定しました。" ).first_or_create
      }
    else
      # 開催未定戻し
      plan.decide_flag = false
      Schedule.where( plan_id: plan.id ).update_all( adopt_flag: false )

      # 開催取り消しフィード作成
      if FeedPlan.where( plan_id: plan.id, happen: "開催が決定しました。" ).exists?
        FeedPlan.where( plan_id: plan.id, happen: "開催が決定しました。" ).delete_all
        Entry.where( plan_id: plan.id ).all.each{ |e|
          FeedPlan.where( plan_id: e.plan_id, user_id: e.user_id, happen: "開催決定が取り消されました。" ).first_or_create
        }
      end
    end

    plan.save
  end
end
