class CreateUserProviders < ActiveRecord::Migration[8.0]
  def change
    create_table :user_providers do |t|
      t.references :user, null: false, foreign_key: true
      t.string :provider, null: false
      t.string :uid, null: false
      t.timestamps
    end

    add_index :user_providers, [:provider, :uid], unique: true
  end
end
