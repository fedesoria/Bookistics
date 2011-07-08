class RemoveAuthFromUsers < ActiveRecord::Migration
  def self.up
    remove_index :users, :uid

    change_table :users do |t|
      t.remove :uid, :provider
      t.string :email
    end
  end

  def self.down
    change_table :users do |t|
      t.remove :email
      t.string :uid, :provider
    end

    add_index :users, :uid
  end
end
