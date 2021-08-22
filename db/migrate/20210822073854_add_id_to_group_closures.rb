class AddIdToGroupClosures < ActiveRecord::Migration[6.1]
  def change
    add_column :sys_group_closures, :id, :uuid, default: "gen_random_uuid()", null: false
    execute "ALTER TABLE sys_group_closures ADD PRIMARY KEY (id);"

    add_column :sys_group_users, :id, :uuid, default: "gen_random_uuid()", null: false
    execute "ALTER TABLE sys_group_users ADD PRIMARY KEY (id);"
  end
end
