require 'rails_helper'

describe "it can search by keywords for a single merchant:" do
  scenario "searches for partial matches that are case insensitive" do
    # searches for 'ocarina of time'
    # How do we determine which should show up
    merchant_1 = create(:merchant, name: "The Ocarina of Time")
    merchant_2 = create(:merchant, name: "Time Stops for Now Woman")
    merchant_3 = create(:merchant, name: "Ocarina Blues")
    # searches for 'wind waker'
    merchant_4 = create(:merchant, name: "Wind Waker")
    merchant_5 = create(:merchant, name: "Waker Dust")
    merchant_6 = create(:merchant, name: "Wind Worms")

    attribute = "name"
    value_1 = "ocarina of time"
    value_1 = "WIND WAKER"

    get "/api/v1/merchants/find?#{attribute}=#{value_1}"
    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(merchant.name).to eq(merchant_1.id)

    get "/api/v1/merchants/find?#{attribute}=#{value_2}"
    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(merchant.name).to eq(merchant_3.id)
    binding.pry
  end

  scenario "searches using created_at"
  scenario "searches using updated_at"
end
