class Api::V1::RevenueController < ApplicationController
  def index
    start_date = params[:start]
    end_date = params[:end]
    render json: RevenueSerializer.new(RevenueFacade.total_revenue(start_date, end_date))
  end
end
