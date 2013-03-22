class MailMagazine < ActiveRecord::Base
  attr_accessible :subject, :content, :last_sent_at, :target
end
