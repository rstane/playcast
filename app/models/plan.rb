# coding: utf-8
class Plan < ActiveRecord::Base
  attr_accessible :budget, :description, :image_url, :max_people, :min_people, :place, :publish_end_at, :publish_start_at, :target_people, :title, :user_id, :cheers_count, :favorites_count, :area, :male_min, :male_max, :female_min, :female_max

  belongs_to :user
  has_many :comments,       :dependent => :destroy
  has_many :favorites,      :dependent => :destroy
  has_many :cheers,         :dependent => :destroy
  has_many :entries,        :dependent => :destroy
  has_many :feeds,          :dependent => :destroy
  has_many :schedules,      :dependent => :destroy
  has_many :participations, :dependent => :destroy
  has_many :categorizes,    :dependent => :destroy
  has_many :categories,     :through => :categorizes
  has_one  :board,          :dependent => :destroy

  # コールバック
  after_create :create_owner_entry
  after_create :create_feed_plan_start
  after_create :create_board

  # バリデーション
  validates :title, presence: true, length: { maximum: 39 }
  validates :description, presence: true, length: { maximum: 1000 }
  validates :place, presence: true, length: { maximum: 500 }
  validates :budget, presence: true, length: { maximum: 100 }
  # validates :min_people, presence: true, numericality: { only_integer: true }
  # validates :max_people, numericality: { only_integer: true, allow_blank: true }
  validates :male_min, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 2 }
  validates :male_max, numericality: { only_integer: true, allow_blank: true, greater_than_or_equal_to: 2 }
  validates :female_min, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 2 }
  validates :female_max, numericality: { only_integer: true, allow_blank: true, greater_than_or_equal_to: 2 }

  # 参加者判定
  def participant?( user_id )
    schedule_ids = Participation.where( plan_id: self.id, user_id: user_id ).pluck(:schedule_id)
#    puts "[ ---------- schedule_ids ---------- ]" ; schedule_ids.tapp ;
    Schedule.where( id: schedule_ids, adopt_flag: true ).exists? ? true : false
  end

  # 開催決定判定
  def hold_decide?
    return true if self.decide_flag == true
    return false
  end

  # 募集終了判定
  def closed?
    return true if self.entry_close_flag == true
    return true if self.schedules.sort{ |a, b| b.try(:close_at).to_i <=> a.try(:close_at).to_i }.first.try(:close_at).to_i <= Time.now.to_i
    return false
  end

  # 男性定員
  def show_male_max
    self.male_max.present? ? "#{self.male_max}人" : "無し"
  end

  # 女性定員
  def show_female_max
    self.female_max.present? ? "#{self.female_max}人" : "無し"
  end

  # 募集終了フラグ判定
  def entry_close?(male_count, female_count)
    # 男性／女性ともに定員に達していたらプラン募集終了
    if (self.male_max.present? and male_count >= self.male_max) and (self.female_max.present? and female_count >= self.female_max)
      # 募集終了
      true
    else
      # 募集中
      false
    end
  end

  # 性別ごと募集終了(定員チェック)
  def gender_entry_close?( gender )
    if gender == "male"
      male_entry_counts   = Participation.where( plan_id: self.id ).includes( :user ).where( "users.gender = ?", "male" ).group( "schedule_id" ).count.sort{ |a, b| b[1].to_i <=> a[1].to_i }
      male_count          = (male_entry_counts.present? ? male_entry_counts.first[1] : 0)

      (self.male_max.present? and male_count >= self.male_max) ? true : false
    elsif gender == "female"
      female_entry_counts = Participation.where( plan_id: self.id ).includes( :user ).where( "users.gender = ?", "female" ).group( "schedule_id" ).count.sort{ |a, b| b[1].to_i <=> a[1].to_i }
      female_count        = (female_entry_counts.present? ? female_entry_counts.first[1] : 0)

      (self.female_max.present? and female_count >= self.female_max) ? true : false
    else
      false
    end
  end

  private

  # プラン投稿者：参加メンバー作成
  def create_owner_entry
    WillEntry.where( user_id: self.user_id, plan_id: self.id ).first_or_create

    entry = Entry.where(
      user_id: self.user_id,
      plan_id: self.id,
      comment: "投稿者"
    ).first_or_create
  end

  # フィード作成
  def create_feed_plan_start
    FeedPlan.create( plan_id: self.id, user_id: self.user_id, happen: "参加募集が開始しました。" )
  end

  # ボード作成
  def create_board
    Board.create( plan_id: self.id )
  end

  # 最大／最小参加人数チェック
  def self.max_min_people_check( plan_id )
    plan = Plan.where( id: plan_id ).includes( :schedules ).first

    # 各スケジュール参加者数降順にカウント
    male_entry_counts   = Participation.where( plan_id: plan.id ).includes( :user ).where( "users.gender = ?", "male" ).group( "schedule_id" ).count.sort{ |a, b| b[1].to_i <=> a[1].to_i }
    female_entry_counts = Participation.where( plan_id: plan.id ).includes( :user ).where( "users.gender = ?", "female" ).group( "schedule_id" ).count.sort{ |a, b| b[1].to_i <=> a[1].to_i }
    male_count          = (male_entry_counts.present? ? male_entry_counts.first[1] : 0)
    female_count        = (female_entry_counts.present? ? female_entry_counts.first[1] : 0)

#    entry_count = Participation.where( plan_id: plan.id ).group( "schedule_id" ).count.sort{ |a, b| b[1].to_i <=> a[1].to_i }
#    max_count = (entry_count.present? ? entry_count.first[1] : 0)

    # 募集終了判定
    # if plan.max_people.present? and max_count >= plan.max_people.to_i
    #   # 募集終了
    #   plan.entry_close_flag = true
    # else
    #   # 募集再開
    #   plan.entry_close_flag = false
    # end
    # 募集終了フラグ判定
    plan.entry_close_flag = plan.entry_close?(male_count, female_count)

    # 開催決定判定
#    if max_count >= plan.min_people.to_i
    if male_count >= plan.male_min and female_count >= plan.female_min
      # 開催決定
      plan.decide_flag = true
      schedule_ids = (male_entry_counts.select{ |x| x[1] >= male_count }.map{ |x| x[0] } + female_entry_counts.select{ |x| x[1] >= female_count }.map{ |x| x[0] })
      Schedule.where( plan_id: plan.id, id: schedule_ids ).update_all( adopt_flag: true )

      # 開催取消フィード削除
      FeedPlan.where( plan_id: plan.id, happen: "開催決定が取り消されました。" ).delete_all

      # 開催決定フィード作成
      Entry.where( plan_id: plan.id ).all.each{ |e|
        FeedPlan.where( plan_id: e.plan_id, user_id: e.user_id, happen: "開催が決定しました！", send_mail_flag: true ).first_or_create
      }
    else
      # 開催未定戻し
      plan.decide_flag = false
      Schedule.where( plan_id: plan.id ).update_all( adopt_flag: false )

      if FeedPlan.where( plan_id: plan.id, happen: "開催が決定しました！" ).exists?
        # 開催決定フィード削除
        FeedPlan.where( plan_id: plan.id, happen: "開催が決定しました！" ).delete_all

        # 開催取り消しフィード作成
        Entry.where( plan_id: plan.id ).all.each{ |e|
          FeedPlan.where( plan_id: e.plan_id, user_id: e.user_id, happen: "開催決定が取り消されました。", send_mail_flag: true ).first_or_create
        }
      end
    end

    plan.save
  end
end
