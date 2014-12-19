class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.string :url
      t.json :params
      t.json :response
      t.string :ip_address

      t.timestamps
    end
  end
end
