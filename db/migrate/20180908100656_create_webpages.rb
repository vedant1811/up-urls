class CreateWebpages < ActiveRecord::Migration[5.2]
  def change
    create_table :webpages do |t|
      t.text :url
      t.text :status

      t.timestamps
    end
  end
end
