namespace :send_mail do
  desc "メール送信"

  # rake send_mail:mail_magazine["rails.dev0115@gmail.com",1]
  task :mail_magazine, [:target, :id] => :environment do |task, args|
    target = args[:target]
    id     = args[:id]

    mail_maga = MailMagazine.where( id: id ).first
    raise "MailMagazine Not Found" if mail_maga.blank?

    if target == "all"
      users = User.all

      users.each.with_index(1) { |user, i|
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