class CreateWupeeNotifications < ActiveRecord::Migration
  def change
    create_table :wupee_notifications do |t|
      t.references :receiver, polymorphic: true, index: { name: 'idx_wupee_notifications_on_receiver_id' }
      t.references :attached_object, polymorphic: true, index: { name: 'idx_wupee_notifications_on_attached_object_id' }
      t.integer :notification_type_id
      t.boolean :is_read, default: false
      t.boolean :is_sent, default: false
      t.boolean :is_wanted, default: true

      t.timestamps null: false
    end

    add_index :wupee_notifications, :notification_type_id, name: 'idx_wupee_notifications_on_notification_type_id'
    add_foreign_key :wupee_notifications, :wupee_notification_types, column: :notification_type_id
  end
end
