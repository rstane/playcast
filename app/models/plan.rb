# coding: utf-8
class Plan < ActiveRecord::Base
  attr_accessible :budget, :description, :image_url, :max_people, :min_people, :place, :publish_end_at, :publish_start_at, :target_people, :title, :user_id

  belongs_to :user
  has_many :comments,    :dependent => :destroy
  has_many :favorites,   :dependent => :destroy
  has_many :entries,     :dependent => :destroy
  has_many :categorizes, :dependent => :destroy
  has_many :feeds,       :dependent => :destroy
  has_many :schedules,   :dependent => :destroy

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

    if max_count >= plan.max_people
      # 募集終了
      plan.entry_close_flag = true
    else
      # 募集再開
      plan.entry_close_flag = false
    end

    if max_count >= plan.min_people
      # 開催決定
      plan.decide_flag = true
      schedule_ids = entry_count.select{ |x| x[1] >= max_count }.map{ |x| x[0] }
      Schedule.where( plan_id: plan.id, id: schedule_ids ).update_all( adopt_flag: true )
    else
      # 開催未定戻し
      plan.decide_flag = false
      Schedule.where( plan_id: plan.id ).update_all( adopt_flag: false )
    end

    plan.save
  end
end
