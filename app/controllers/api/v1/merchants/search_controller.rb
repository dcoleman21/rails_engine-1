class Api::V1::Merchants::SearchController < ApplicationController
  def show
    binding.pry
    params will come through as the attribute
    These will be our query params
    name
    created_at
    updated_at
    Merchant model should hold the logic for searching through all the Merchants and finding by attribute matching
    render json: MerchantSerializer.new(Merchant.single_finder(query_params))
  end
end
