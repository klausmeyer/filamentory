class SpoolsController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :set_spools, only: %i[index create update]

  def index; end

  def new
    @spool = Spool.new
  end

  def create
    @spool = Spool.new(spool_params)

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

      render :new
    end
  end

  def edit
    @spool = Spool.find params[:id]
  end

  def update
    @spool = Spool.find params[:id]
    @spool.attributes = spool_params

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

  def spool_params
    params.expect(spool: [ :filament_id, :inventory_tag, :gross_weight_grams, :ovp, :refill_only ])
  end

  def set_spools
    @spools = Spool.sorted_by_filament
  end
end
