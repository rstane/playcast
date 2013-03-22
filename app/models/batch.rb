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

  # メルマガ送付
  #  ruby script/rails runner "Batch.send_mail_magazine( target: 'all', id: 1 )"
  def self.send_mail_magazine( target: Settings.mailer_sender, id: nil )
    mail_maga = MailMagazine.where( id: id ).first
    return "MailMagazine Not Found" if mail_maga.blank?

    if target == "all"
      users = User.all

      users.each_with_index(1) { |user, i|
        begin
          UserMailer.mail_magazine( user.email, mail_maga ).deliver
          puts "[ #{i} : #{user.email} ]"
        rescue Exception => e
          puts "[ ---------- Exception ---------- ]" ; e.tapp ;
        end
      }

      mail_maga.update_attributes!( target: target, last_sent_at: Time.now )
    else
      begin
        UserMailer.mail_magazine( target, mail_maga ).deliver
        result = mail_maga.update_attributes!( target: target, last_sent_at: Time.now )
        puts "[ ---------- result ---------- ]" ; result.tapp ;
      rescue Exception => e
        puts "[ ---------- Exception ---------- ]" ; e.tapp ;
      end
    end
  end
end
