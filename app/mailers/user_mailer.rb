# coding: utf-8
class UserMailer < ActionMailer::Base
  default from: "Playcast運営事務局 <#{Settings.mailer_sender}>"
  layout 'user_mailer'

  # 開催決定／取消メール
  def plan_feed( plan, feed, user )
    @plan = plan
    @feed = feed
    @user = user

    mail(
      to:      user.email,
      subject: "【#{Settings.app_name}】#{feed.sentence}",
    )
  end

  # メールマガジン
  def mail_magazine( address, mail_magazine )
    @content = mail_magazine.content

    mail(
      to:      address,
      subject: "【#{Settings.app_name}】#{mail_magazine.subject}",
    )
  end
end
