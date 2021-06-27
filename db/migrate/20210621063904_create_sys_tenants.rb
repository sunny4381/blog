class CreateSysTenants < ActiveRecord::Migration[6.1]
  def change
    create_table :sys_tenants, id: :uuid do |t|
      t.string :name, null: false
      t.text :memo
      t.datetime :enabled_at
      t.datetime :disabled_at

      t.timestamps
    end
    add_index :sys_tenants, :name, unique: true
  end
end
