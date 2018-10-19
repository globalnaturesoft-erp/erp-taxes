module Erp
  module Taxes
    module Backend
      class TaxesController < Erp::Backend::BackendController
        before_action :set_tax, only: [:archive, :unarchive, :edit, :update, :set_active, :set_deleted]
        before_action :set_taxes, only: [:archive_all, :unarchive_all]
        
        # GET /taxes
        def index
          if Erp::Core.available?("ortho_k")
            authorize! :system_taxes_taxes_index, nil
          end
        end
        
        # POST /taxes/list
        def list
          if Erp::Core.available?("ortho_k")
            authorize! :system_taxes_taxes_index, nil
          end
          
          @taxes = Tax.search(params).paginate(:page => params[:page], :per_page => 10)
          
          render layout: nil
        end
    
        # GET /taxes/new
        def new
          @tax = Tax.new
          
          authorize! :creatable, @tax
          
          # default scope
          if params[:scope].present?
            @tax.scope = params[:scope]
          end
          
          if request.xhr?
            render '_form', layout: nil, locals: {tax: @tax}
          end
        end
    
        # GET /taxes/1/edit
        def edit
          authorize! :updatable, @tax
        end
    
        # POST /taxes
        def create
          @tax = Tax.new(tax_params)
          
          authorize! :creatable, @tax
          
          @tax.creator = current_user
          
          if @tax.save
            @tax.set_active
            if request.xhr?
              render json: {
                status: 'success',
                text: @tax.name,
                value: @tax.id
              }
            else
              redirect_to erp_taxes.edit_backend_tax_path(@tax), notice: t('.success')
            end
          else
            if params.to_unsafe_hash['format'] == 'json'
              render '_form', layout: nil, locals: {tax: @tax}
            else
              render :new
            end            
          end
        end
    
        # PATCH/PUT /taxes/1
        def update
          authorize! :updatable, @tax
          
          if @tax.update(tax_params)
            if request.xhr?
              render json: {
                status: 'success',
                text: @tax.name,
                value: @tax.id
              }
            else
              redirect_to erp_taxes.edit_backend_tax_path(@tax), notice: t('.success')
            end
          else
            render :edit
          end
        end
        
        # Archive /taxes/archive?id=1
        def archive      
          @tax.archive
          
          respond_to do |format|
          format.json {
            render json: {
            'message': t('.success'),
            'type': 'success'
            }
          }
          end
        end
        
        # Unarchive /taxes/unarchive?id=1
        def unarchive
          @tax.unarchive
          
          respond_to do |format|
          format.json {
            render json: {
            'message': t('.success'),
            'type': 'success'
            }
          }
          end
        end
        
        # Archive /taxes/archive_all?ids=1,2,3
        def archive_all         
          @taxes.archive_all
          
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end
        
        # Unarchive /taxes/unarchive_all?ids=1,2,3
        def unarchive_all
          @taxes.unarchive_all
          
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end
        
        # Activate /taxes/set_active?id=1
        def set_active
          authorize! :activatable, @tax
          
          @tax.set_active

          respond_to do |format|
          format.json {
            render json: {
            'message': t('.success'),
            'type': 'success'
            }
          }
          end
        end

        # Deleted /taxes/set_deleted?id=1
        def set_deleted
          authorize! :cancelable, @tax
          
          @tax.set_deleted

          respond_to do |format|
          format.json {
            render json: {
            'message': t('.success'),
            'type': 'success'
            }
          }
          end
        end
        
        def dataselect
          respond_to do |format|
            format.json {
              render json: Tax.dataselect(params)
            }
          end
        end
    
        private
          # Use callbacks to share common setup or constraints between actions.
          def set_tax
            @tax = Tax.find(params[:id])
          end
          
          def set_taxes
            @taxes = Tax.where(id: params[:ids])
          end
    
          # Only allow a trusted parameter "white list" through.
          def tax_params
            params.fetch(:tax, {}).permit(:name, :short_name, :scope, :computation, :amount)
          end
      end
    end
  end
end
