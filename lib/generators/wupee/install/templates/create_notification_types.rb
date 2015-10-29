class CreateNotificationTypes < ActiveRecord::Migration
  def change
    create_table :notification_types do |t|
      t.string :name
      t.timestamps null: false
    end

    add_index :notification_types, :name, unique: true
  end
end
