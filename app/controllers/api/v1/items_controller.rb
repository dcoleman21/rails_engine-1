class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    new_item = Item.new(item_params)
    render json: ItemSerializer.new(new_item) if new_item.save
  end

  def destroy
    Item.destroy(params[:id])
    head :no_content
  end

  private

  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id, :created_at, :updated_at)
  end
end
