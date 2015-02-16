class CreateNotification < ActiveRecord::Migration
  def change
    create_table :notify_with_notifications do |t|
      t.references :receiver, polymorphic: true
      t.references :attached_object, polymorphic: true
      t.integer :notification_type_id
      t.boolean :is_read, default: false
      t.boolean :is_send, default: false

      t.timestamps null: false
    end
  end
end
