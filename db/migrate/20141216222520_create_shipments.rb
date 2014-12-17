class CreateShipments < ActiveRecord::Migration
  def change
    create_table :shipments do |t|
      t.string :name
      t.string :city
      t.string :state
      t.string :postal_code
      t.float :weight
      t.boolean :cylinder

      t.timestamps
    end
  end
end
