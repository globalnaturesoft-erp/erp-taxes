user = Erp::User.first
taxes = [['VAT 0%', 'VAT 0%', 0], ['VAT 10%', 'VAT 10%', 10]]

Erp::Taxes::Tax.all.destroy_all

taxes.each_with_index do |t,index|
    Erp::Taxes::Tax.create(
        name: 'SO-' + taxes[index][0],
        short_name: taxes[index][1],
        scope: Erp::Taxes::Tax::TAX_SCOPE_SALES,
        computation: Erp::Taxes::Tax::TAX_COMPUTATION_PRICE,
        amount: [0, 10].sample,
        creator_id: user.id
    )
end

taxes.each_with_index do |t,index|
    Erp::Taxes::Tax.create(
        name: 'PO-' + taxes[index][0],
        short_name: taxes[index][1],
        scope: Erp::Taxes::Tax::TAX_SCOPE_PURCHASES,
        computation: Erp::Taxes::Tax::TAX_COMPUTATION_PRICE,
        amount: taxes[index][2],
        creator_id: user.id
    )
end