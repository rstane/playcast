# coding: utf-8
class BoardComment < Comment
  belongs_to :board

  # コールバック
  after_create :create_feed_board_comment

  private

  # フィード作成
  def create_feed_board_comment
    plan = Plan.where( id: self.plan_id ).first
    FeedComment.create( comment_id: self.id, plan_id: self.plan_id, user_id: plan.user_id, happen: "待ち合わせ相談ルームにコメントが投稿されました。", send_mail_flag: true )

    # 参加者フィード生成
    schedules = Schedule.where( plan_id: plan.id, adopt_flag: true ).includes( :participations )
    schedules.each { |s|
      s.participations.each { |participation|
        # コメント投稿者で無ければ
        unless self.user_id == participation.user_id
          # フィード作成
          feed = FeedComment.where( comment_id: self.id, plan_id: self.plan_id, user_id: participation.user_id, happen: "待ち合わせ相談ルームにコメントが投稿されました。", send_mail_flag: false ).first_or_initialize

          if feed.id.blank?
            if feed.save
              # メール送信
              UserMailer.plan_feed( feed.plan, feed, feed.user ).deliver
            end
          end
        end
      }
    }
  end
end
