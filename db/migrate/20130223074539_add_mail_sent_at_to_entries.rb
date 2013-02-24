class AddMailSentAtToEntries < ActiveRecord::Migration
  def change
    add_column :feeds, :mail_sent_at, :timestamp
  end
end
