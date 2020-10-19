class Api::V1::Merchants::SearchController < ApplicationController
  def show
    render json: MerchantSerializer.new(Merchant.single_finder(attribute, query))
  end

  def index
    render json: MerchantSerializer.new(Merchant.multi_finder(attribute, query))
  end

  private

  def query_params
    params.permit(:name, :created_at, :updated_at)
  end

  def attribute
    query_params.keys.first
  end

  def query
    query_params[attribute]
  end
end
