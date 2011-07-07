class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :provider
      t.string :uid
      t.string :name

      t.timestamps
    end

    add_index :users, :uid
  end

  def self.down
    remove_index :users, :uid

    drop_table :users
  end
end
