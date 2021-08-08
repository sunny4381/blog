class CreateShares < ActiveRecord::Migration[6.1]
  def change
    create_table :shares, id: :uuid do |t|
      t.belongs_to :tenant, type: :uuid, null: false
      t.string :type, null: false
      t.string :name, null: false
      t.integer :size

      t.datetime :deleted_at
      t.timestamps
    end

    create_table :share_closures, id: false do |t|
      t.belongs_to :parent, type: :uuid, null: false
      t.belongs_to :child, type: :uuid, null: false

      t.timestamps
    end
    add_index :share_closures, %i[parent_id child_id], unique: true
  end
end
