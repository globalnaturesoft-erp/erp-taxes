require_dependency "erp/application_controller"

module Erp
  module Taxes
    module Backend
      class TaxesController < Erp::Backend::BackendController
        before_action :set_tax, only: [:edit, :update, :destroy]
        before_action :set_taxes, only: [:delete_all, :archive_all, :unarchive_all]
        
        # GET /taxes
        def index
        end
        
        # POST /taxes/list
        def list
          @taxes = Tax.search(params).paginate(:page => params[:page], :per_page => 10)
          
          render layout: nil
        end
    
        # GET /taxes/new
        def new
          @tax = Tax.new
          
          if request.xhr?
            render '_form', layout: nil, locals: {tax: @tax}
          end
        end
    
        # GET /taxes/1/edit
        def edit
        end
    
        # POST /taxes
        def create
          @tax = Tax.new(tax_params)
          @tax.creator = current_user
          
          if @tax.save
            if params.to_unsafe_hash['format'] == 'json'
              render json: {
                status: 'success',
                text: @tax.name,
                value: @tax.id
              }
            else
              redirect_to erp_taxes.edit_backend_tax_path(@tax), notice: 'Tax was successfully created.'
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
          if @tax.update(tax_params)
            redirect_to erp_taxes.edit_backend_tax_path(@tax), notice: 'Tax was successfully updated.'
          else
            render :edit
          end
        end
    
        # DELETE /taxes/1
        def destroy
          @tax.destroy
          respond_to do |format|
            format.html { redirect_to erp_taxes.backend_taxes_path, notice: 'Tax was successfully destroyed.' }
            format.json {
              render json: {
                'message': 'Tax was successfully destroyed.',
                'type': 'success'
              }
            }
          end
        end
        
        # DELETE /taxes/delete_all?ids=1,2,3
        def delete_all         
          @taxes.destroy_all
          
          respond_to do |format|
            format.json {
              render json: {
                'message': 'Taxes were successfully destroyed.',
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
                'message': 'Taxes were successfully archived.',
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
                'message': 'Taxes were successfully active.',
                'type': 'success'
              }
            }
          end          
        end
        
        def dataselect
          respond_to do |format|
            format.json {
              render json: Tax.dataselect(params[:keyword])
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
