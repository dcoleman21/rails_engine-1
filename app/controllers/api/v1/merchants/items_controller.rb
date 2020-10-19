class Api::V1::Merchants::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.where(merchant: params[:merchant_id]))
  end
end
