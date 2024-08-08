class RenameAndChangeColumnTypeInProponents < ActiveRecord::Migration[5.2]
  def change
    rename_column :proponents, :phones, :phone
    change_column :proponents, :phone, :string
  end
end
