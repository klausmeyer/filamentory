class SpoolsController < ApplicationController
  def index
    @spools = Spool
      .eager_load(filament: { product: [ :brand, :material, :variant ] })
      .order(brands: { name: :asc }, materials: { name: :asc }, variants: { name: :asc })
  end
end
