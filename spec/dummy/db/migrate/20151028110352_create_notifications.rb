class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :receiver, polymorphic: true
      t.references :attached_object, polymorphic: true
      t.belongs_to :notification_type, foreign_key: true
      t.integer :notification_type_id
      t.boolean :is_read, default: false
      t.boolean :is_sent, default: false

      t.timestamps null: false
    end
  end
end
