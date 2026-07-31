class StatisticsController < ApplicationController
  before_action :require_authenticated_user

  def index
    @statistics = Statistic.all
  end
end
