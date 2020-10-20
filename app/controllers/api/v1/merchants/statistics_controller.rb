class Api::V1::Merchants::StatisticsController < ApplicationController
  def revenue
    quantity = params[:quantity]
    render json: MerchantSerializer.new(Merchant.most_revenue(quantity))
  end
  
  def items
    quantity = params[:quantity]
    render json: MerchantSerializer.new(Merchant.most_items(quantity))
  end
end
