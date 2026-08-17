class ActivitiesController < ApplicationController
  def index
    @activities = ActivityHistory.all.order(created_at: :desc)
  end
end
