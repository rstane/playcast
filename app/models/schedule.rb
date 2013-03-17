class Schedule < ActiveRecord::Base
  attr_accessible :adopt_flag, :candidate_day, :plan_id, :close_at

  belongs_to :plan
  has_many :participations

  # コールバック
  before_save :setting_close_at
  after_create :create_owner_entry

  private

  #------------------#
  # setting_close_at #
  #------------------#
  # 募集終了時刻格納
  def setting_close_at
    if self.candidate_day.present?
      self.close_at = self.candidate_day.end_of_day
    end
  end

  #--------------------#
  # create_owner_entry #
  #--------------------#
  # プラン投稿者：参加作成
  def create_owner_entry
    if self.candidate_day.present?
      entry = Entry.where( user_id: self.plan.user_id, plan_id: self.plan_id ).first

      Participation.where(
        user_id: entry.user_id,
        plan_id: entry.plan_id,
        schedule_id: self.id,
        entry_id: entry.id
      ).first_or_create
    end
  end
end
