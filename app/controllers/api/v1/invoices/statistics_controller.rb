class Api::V1::Invoices::StatisticsController < ApplicationController
  def index
    render json: Invoice.most_expensive()
  end
end
