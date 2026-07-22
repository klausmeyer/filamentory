class SpoolsController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :set_spools, only: %i[index create update destroy]
  before_action :set_spool, only: %i[edit update destroy]

  def index; end

  def new
    @spool = Spool.new
  end

  def create
    @spool = Spool.new(spool_params)

    if @spool.save
      respond_to do |format|
        format.html do
          redirect_to action: :index, notice: t(".success")
        end
        format.turbo_stream do
          flash.now[:notice] = t(".success")
        end
      end
    else
      flash.now[:alert] = t(".error")

      render :new
    end
  end

  def edit; end

  def update
    @spool.attributes = spool_params

    if @spool.save
      respond_to do |format|
        format.html do
          redirect_to action: :index, notice: t(".success")
        end
        format.turbo_stream do
          flash.now[:notice] = t(".success")
        end
      end
    else
      flash.now[:alert] = t(".error")

      render :edit
    end
  end

  def destroy
    flash[:notice] = @spool.destroy ? t(".success") : t(".error")

    respond_to do |format|
      format.html { redirect_to action: :index }
      format.turbo_stream
    end
  end

  private

  def spool_params
    params.expect(spool: [ :filament_id, :inventory_tag, :gross_weight_grams, :ovp, :refill_only ])
  end

  def set_spools
    @spools = Spool.sorted_by_filament
  end

  def set_spool
    @spool = Spool.find params[:id]
  end
end
