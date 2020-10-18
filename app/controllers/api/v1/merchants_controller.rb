class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
  end

  def create
    ActiveRecord::Base.connection.reset_pk_sequence!('merchants')
    new_merchant = Merchant.new(merchant_params)
    render json: MerchantSerializer.new(new_merchant) if new_merchant.save
  end

  def destroy
    Merchant.destroy(params[:id])
    head :no_content
  end

  private

  def merchant_params
    params.permit(:name, :created_at, :updated_at)
  end
end
