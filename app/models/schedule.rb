class Schedule < ActiveRecord::Base
  attr_accessible :adopt_flag, :candidate_day, :plan_id, :close_at

  belongs_to :plan
  has_many :participations

  # コールバック
  before_save :setting_close_at

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
end
