class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    return !Merchant.exists?(params[:id]) ?
      (render :status => 404) :
      (render json: MerchantSerializer.new(Merchant.find(params[:id])))
  end

  def create
    Merchant.reset_primary_keys
    new_merchant = Merchant.new(merchant_params)
    return new_merchant.save ?
      (render json: MerchantSerializer.new(new_merchant)) :
      (render :status => 404)
  end

  def destroy
    Merchant.destroy(params[:id])
    head :no_content
  end

  def update
    render json: MerchantSerializer.new(Merchant.update(params[:id], merchant_params))
  end

  private

  def merchant_params
    params.permit(:name, :created_at, :updated_at)
  end
end
