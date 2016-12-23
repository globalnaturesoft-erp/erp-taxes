module Erp::Taxes
  class Tax < ApplicationRecord
		validates :name, :amount, :scope, :computation, :presence => true
    belongs_to :creator, class_name: "Erp::User"
    
    # class const
    TAX_SCOPE_SALES = 'sales'
    TAX_SCOPE_PURCHASES = 'purchases'
    TAX_SCOPE_OTHERS = 'others'
    TAX_COMPUTATION_FIXED = 'fixed'
    TAX_COMPUTATION_PRICE = 'percentage_of_price'
    
    # get tax scope
    def self.get_tax_scope_options()
      [
        {text: I18n.t('sales'), value: 'sales'},
        {text: I18n.t('purchases'), value: 'purchases'},
        {text: I18n.t('others'), value: 'others'}
      ]
    end
    
    # get tax computation
    def self.get_tax_computation_options()
      [
        {text: I18n.t('fixed'), value: 'fixed'},
        {text: I18n.t('percentage_of_price'), value: 'percentage_of_price'}
      ]
    end
    
    # Filters
    def self.filter(query, params)
      params = params.to_unsafe_hash
      and_conds = []
      
      # show archived items condition - default: false
			show_archived = false
			
			#filters
			if params["filters"].present?
				params["filters"].each do |ft|
					or_conds = []
					ft[1].each do |cond|
						# in case filter is show archived
						if cond[1]["name"] == 'show_archived'
							# show archived items
							show_archived = true
						else
							or_conds << "#{cond[1]["name"]} = '#{cond[1]["value"]}'"
						end
					end
					and_conds << '('+or_conds.join(' OR ')+')' if !or_conds.empty?
				end
			end
      
      #keywords
      if params["keywords"].present?
        params["keywords"].each do |kw|
          or_conds = []
          kw[1].each do |cond|
						if cond[1]["name"] == 'search_name'
							or_conds << "(LOWER(erp_taxes_taxes.name) LIKE '%#{cond[1]["value"].downcase.strip}%') OR (LOWER(erp_taxes_taxes.short_name) LIKE '%#{cond[1]["value"].downcase.strip}%')"
						else
							or_conds << "LOWER(#{cond[1]["name"]}) LIKE '%#{cond[1]["value"].downcase.strip}%'"			
            end
          end
          and_conds << '('+or_conds.join(' OR ')+')'
        end
      end
			
			# showing archived items if show_archived is not true
			query = query.where(archived: false) if show_archived == false
			
      query = query.where(and_conds.join(' AND ')) if !and_conds.empty?
      
      return query
    end
    
    def self.search(params)
      query = self.all
      query = self.filter(query, params)
      
      # order
      if params[:sort_by].present?
        order = params[:sort_by]
        order += " #{params[:sort_direction]}" if params[:sort_direction].present?
        
        query = query.order(order)
      end
      
      return query
    end
    
    # data for dataselect ajax
    def self.dataselect(params)
      query = self.all
      
      if params[:scope].present?
        query = self.where(scope: params[:scope])
      end
      
      if params[:keyword].present?
        keyword = params[:keyword].strip.downcase
        query = query.where('LOWER(name) LIKE ?', "%#{keyword}%")
      end
      
      query = query.limit(8).map{|tax| {value: tax.id, text: tax.name} }
    end
    
    def archive
			update_columns(archived: true)
		end
		
		def unarchive
			update_columns(archived: false)
		end
    
    def self.archive_all
			update_all(archived: true)
		end
    
    def self.unarchive_all
			update_all(archived: false)
		end
  end
end
