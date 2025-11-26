class CreatePageContents < ActiveRecord::Migration[7.1]
  def change
    create_table :page_contents do |t|
      t.string :title
      t.text :content
      t.string :slug

      t.timestamps
    end
    add_index :page_contents, :slug, unique: true
  end
end
