class CreateWupeeNotificationTypeConfigurations < ActiveRecord::Migration
  def change
    create_table :wupee_notification_type_configurations do |t|
      t.belongs_to :notification_type, foreign_key: true
      t.belongs_to :receiver, polymorphic: true
      t.integer :value, default: 0
      t.timestamps null: false
    end

    add_index :wupee_notification_type_configurations, [:notification_type_id], name: "idx_wupee_notif_type_config_on_notification_type_id"
    add_index :wupee_notification_type_configurations, [:receiver_type, :receiver_id], name: "idx_wupee_notif_typ_config_on_receiver_type_and_receiver_id", unique: true
  end
end
