class AddSendMailFlagToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :send_mail_flag, :boolean, default: false
    add_column :feeds, :sentence, :text
  end
end
