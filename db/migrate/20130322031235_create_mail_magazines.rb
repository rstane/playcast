class CreateMailMagazines < ActiveRecord::Migration
  def change
    create_table :mail_magazines do |t|
      t.string :subject
      t.text :content
      t.timestamp :last_sent_at
      t.string :target

      t.timestamps
    end
  end
end
