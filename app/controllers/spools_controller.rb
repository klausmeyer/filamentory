class SpoolsController < ApplicationController
  def index
    @spools = Spool.sorted_by_filament
  end
end
