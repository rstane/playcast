module Batch
  private

  # 募集終了フラグ更新
  #  ruby script/rails runner "Batch.entry_close_check"
  def self.entry_close_check
    plans = Plan.where( entry_close_flag: false ).all
    plans.each { |plan|
      if plan.closed?
        plan.update_attributes( entry_close_flag: true )
      end
    }
  end
end
