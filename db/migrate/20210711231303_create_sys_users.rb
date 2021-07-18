class CreateSysUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :sys_users, id: :uuid do |t|
      t.belongs_to :tenant, type: :uuid, null: false
      t.string :uid, null: false
      t.string :name, null: false
      t.string :password_digest
      t.string :email
      t.string :title
      t.datetime :enabled_at
      t.datetime :disabled_at

      t.timestamps
    end
    add_index :sys_users, %i[tenant_id uid], unique: true

    create_table :sys_groups, id: :uuid do |t|
      t.belongs_to :tenant, type: :uuid, null: false
      t.string :gid, null: false
      t.string :name, null: false
      t.integer :depth, null: false

      t.timestamps
    end
    add_index :sys_groups, %i[tenant_id gid], unique: true

    create_table :sys_group_closures, id: false do |t|
      t.belongs_to :parent, type: :uuid, null: false
      t.belongs_to :child, type: :uuid, null: false

      t.timestamps
    end
    add_index :sys_group_closures, %i[parent_id child_id], unique: true

    create_table :sys_groups_users, id: false do |t|
      t.belongs_to :group, type: :uuid, null: false
      t.belongs_to :user, type: :uuid, null: false

      t.timestamps
    end
    add_index :sys_groups_users, %i[user_id group_id], unique: true
  end
end
