# coding: utf-8
class UserMailer < ActionMailer::Base
  default from: Settings.mailer_sender
  layout 'user_mailer'

  # 開催決定／取消メール
  def plan_feed( plan, feed, user )
    @plan = plan
    @feed = feed
    @user = user

    mail(
      to:      user.email,
      subject: "【#{Settings.app_name}】 「#{plan.title}」の#{feed.happen}",
    )
  end
end
