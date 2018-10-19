class AddStatusToErpTaxesTaxes < ActiveRecord::Migration[5.1]
  def change
    add_column :erp_taxes_taxes, :status, :string
  end
end
