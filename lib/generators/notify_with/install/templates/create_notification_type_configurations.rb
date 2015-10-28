class CreateNotificationTypeConfigurations < ActiveRecord::Migration
  def change
    create_table :notification_type_configurations do |t|
      t.belongs_to :notification_type, index: true, foreign_key: true
      t.belongs_to :receiver, polymorphic: true
      t.integer :value, default: 0
      t.timestamps null: false
    end

    add_index :notification_type_configurations, [:receiver_type, :receiver_id], name: "idx_notif_typ_config_on_receiver_type_and_receiver_id"
  end
end
