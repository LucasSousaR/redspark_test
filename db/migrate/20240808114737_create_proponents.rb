class CreateProponents < ActiveRecord::Migration[5.2]
  def change
    create_table :proponents do |t|
      t.string :name
      t.string :cpf
      t.date :birthday
      t.string :street
      t.string :number
      t.string :district
      t.string :city
      t.string :state
      t.string :cep
      t.text :phones
      t.decimal :wage
      t.decimal :discount_inss

      t.timestamps
    end
  end
end
