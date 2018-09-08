class CreateWebpages < ActiveRecord::Migration[5.2]
  def change
    create_table :webpages do |t|
      t.text :url, null: false
      t.text :status

      t.index :url, unique: true
      t.timestamps
    end
  end
end
