class CreateAuthentications < ActiveRecord::Migration
  def self.up
    create_table :authentications do |t|
      t.string :uid, :null => false
      t.string :provider, :null => false
      t.references :user

      t.timestamps
    end

    add_index :authentications, :uid
  end

  def self.down
    remove_index :authentications, :uid
    drop_table :authentications
  end
end
