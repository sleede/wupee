class CreateWupeeNotificationTypeConfigurations < ActiveRecord::Migration[5.0]
  def change
    create_table :wupee_notification_type_configurations do |t|
      t.belongs_to :notification_type, index: { name: 'idx_wupee_notif_type_config_on_notification_type_id' }
      t.belongs_to :receiver, polymorphic: true, index: { name: 'idx_wupee_notif_type_config_on_receiver_id' }
      t.integer :value, default: 0
      t.timestamps null: false
    end

    add_foreign_key :wupee_notification_type_configurations, :wupee_notification_types, column: :notification_type_id
    add_index :wupee_notification_type_configurations, [:receiver_type, :receiver_id], name: 'idx_wupee_notif_typ_config_on_receiver_type_and_receiver_id'
  end
end
