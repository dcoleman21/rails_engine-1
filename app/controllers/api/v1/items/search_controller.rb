class Api::V1::Items::SearchController < ApplicationController
  def show
    render json: ItemSerializer.new(Item.single_finder(attribute, query))
  end

  def index
    render json: ItemSerializer.new(Item.multi_finder(attribute, query))
  end

  private

  def query_params
    params.permit(:name, :description, :unit_price, :created_at, :updated_at)
  end

  def attribute
    query_params.keys.first
  end

  def query
    query_params[attribute]
  end
end
