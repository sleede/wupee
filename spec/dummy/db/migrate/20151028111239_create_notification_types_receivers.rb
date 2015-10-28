class CreateNotificationTypesReceivers < ActiveRecord::Migration
  def change
    create_table :notification_types_receivers do |t|
      t.belongs_to :notification_type, index: true, foreign_key: true
      t.belongs_to :receiver, polymorphic: true
      t.timestamps null: false
    end

    add_index :notification_types_receivers, [:receiver_type, :receiver_id], name: "idx_notif_typ_receiv_on_receiver_type_and_receiver_id"
  end
end
