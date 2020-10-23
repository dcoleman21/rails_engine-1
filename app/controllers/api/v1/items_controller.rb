class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    return !Item.exists?(params[:id]) ?
      (render :status => 404) :
      (render json: ItemSerializer.new(Item.find(params[:id])))
  end

  def create
    Item.reset_primary_keys
    new_item = Item.new(item_params)
    return new_item.save ?
      (render json: ItemSerializer.new(new_item)) :
      (render :status => 404)
  end

  def destroy
    Item.destroy(params[:id])
    head :no_content
  end

  def update
    render json: ItemSerializer.new(Item.update(params[:id], item_params))
  end

  private

  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id, :created_at, :updated_at)
  end
end
