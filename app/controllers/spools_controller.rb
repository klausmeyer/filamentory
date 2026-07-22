class SpoolsController < ApplicationController
  include ActionView::RecordIdentifier

  def index
    @spools = Spool.sorted_by_filament
  end

  def edit
    @spool = Spool.find params[:id]
  end

  def update
    @spool = Spool.find params[:id]
    @spool.attributes = update_params

    if @spool.save
      respond_to do |format|
        format.html do
          flash[:notice] = t(".success")
          redirect_to action: :index
        end
        format.turbo_stream
      end
    else
      flash.now[:alert] = t(".error")

      render :edit
    end
  end

  private

  def update_params
    params.expect(spool: [ :filament_id, :inventory_tag, :gross_weight_grams, :ovp, :refill_only ])
  end
end
