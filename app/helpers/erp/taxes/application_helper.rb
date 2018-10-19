module Erp
  module Taxes
    module ApplicationHelper
      def tax_dropdown_actions(tax)
        actions = []
        
        actions << {
            text: '<i class="fa fa-edit"></i> '+t('edit'),
            href: erp_taxes.edit_backend_tax_path(tax)
        } if can? :updatable, tax
        
        actions << {
            text: '<i class="fa fa-eye-slash"></i> '+t('archive'),
            url: erp_taxes.archive_backend_taxes_path(id: tax),
            data_method: 'PUT',
            hide: tax.archived,
            class: 'ajax-link',
            data_confirm: t('.archive_confirm')
        } if false
        
        actions << {
            text: '<i class="fa fa-eye"></i> '+t('unarchive'),
            url: erp_taxes.unarchive_backend_taxes_path(id: tax),
            data_method: 'PUT',
            hide: !tax.archived,
            class: 'ajax-link',
            data_confirm: t('.unarchive_confirm')
        } if false
        
        actions << {
            text: '<i class="fa fa-trash"></i> '+t('.activate'),
            url: erp_taxes.set_active_backend_taxes_path(id: tax.id),
            data_method: 'PUT',
            data_confirm: t('.set_active_confirm'),
            class: 'ajax-link'
        } if can? :activatable, tax
        
        if can? :cancelable, tax
            if (can? :updatable, tax) or (can? :activatable, tax)
                actions << { divider: true }
            end
        end
        
        actions << {
            text: '<i class="fa fa-trash"></i> '+t('.delete'),
            url: erp_taxes.set_deleted_backend_taxes_path(id: tax.id),
            data_method: 'PUT',
            data_confirm: t('.delete_confirm'),
            class: 'ajax-link'
        } if can? :cancelable, tax
        
        erp_datalist_row_actions(actions) if !actions.empty?
      end
    end
  end
end
