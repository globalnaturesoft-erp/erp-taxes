class CreateErpTaxesTaxes < ActiveRecord::Migration[5.0]
  def change
    create_table :erp_taxes_taxes do |t|
      t.string :name
      t.string :short_name
      t.string :scope
      t.string :computation
      t.decimal :amount, default: 0.00
      t.boolean :archived, default: false
      t.references :creator, index: true, references: :erp_users

      t.timestamps
    end
  end
end
