class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.text :content
      t.integer :rate
      t.references :user, :product, foreign_key: true

      t.timestamps
    end
  end
end
