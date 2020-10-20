class Api::V1::Merchants::StatisticsController < ApplicationController
  def most_revenue
    quantity = params[:quantity]
    render json: MerchantSerializer.new(Merchant.most_revenue(quantity))
  end

  def items
    quantity = params[:quantity]
    render json: MerchantSerializer.new(Merchant.most_items(quantity))
  end

  def show
    merchant = Merchant.find(params[:merchant_id])
    render json: RevenueSerializer.new(merchant.revenue)
  end
end
