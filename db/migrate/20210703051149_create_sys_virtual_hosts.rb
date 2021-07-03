class CreateSysVirtualHosts < ActiveRecord::Migration[6.1]
  def change
    create_table :sys_virtual_hosts, id: :uuid do |t|
      t.references :parent, type: :uuid, polymorphic: true
      t.string :host, null: false
      t.string :path, null: false
      t.integer :depth

      t.timestamps
    end
  end
end
