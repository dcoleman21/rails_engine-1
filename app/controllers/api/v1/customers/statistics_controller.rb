class Api::V1::Customers::StatisticsController < ApplicationController
  def index
    test = render json: Customer.best_repeater(params[:quantity])
  end
end
