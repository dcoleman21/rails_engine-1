require 'rails_helper'

describe "it can search by keywords for a single merchant:" do
  scenario "searches for matches that are case insensitive" do
    attribute = "name"
    value_1 = "ocarina"
    merchant_1 = create(:merchant, name: "The Ocarina of Time")
    merchant_2 = create(:merchant, name: "Time Stops for Now Woman")
    merchant_3 = create(:merchant, name: "Ocarina Blues")

    value_2 = "WIND"
    merchant_4 = create(:merchant, name: "Wind Waker")
    merchant_5 = create(:merchant, name: "Waker Dust")
    merchant_6 = create(:merchant, name: "Wind Worms")


    get "/api/v1/merchants/find?#{attribute}=#{value_1}"
    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(merchant[:id].to_i).to eq(merchant_1.id)
    expect(merchant[:id].to_i).to_not eq(merchant_2.id)
    expect(merchant[:id].to_i).to_not eq(merchant_3.id)
    expect(merchant[:attributes][:name].downcase).to include(value_1.downcase)

    get "/api/v1/merchants/find?#{attribute}=#{value_2}"
    expect(response).to be_successful
    merchant = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(merchant[:id].to_i).to eq(merchant_4.id)
    expect(merchant[:id].to_i).to_not eq(merchant_5.id)
    expect(merchant[:id].to_i).to_not eq(merchant_6.id)
    expect(merchant[:attributes][:name].downcase).to include(value_2.downcase)
  end

  scenario "searches for partial matches that are case insensitive" do
    attribute = "name"
    value = "ill"
    merchant_1 = create(:merchant, name: "Schiller")
    merchant_2 = create(:merchant, name: "Tillman Group")
    merchant_3 = create(:merchant, name: "Williamson Group")

    get "/api/v1/merchants/find?#{attribute}=#{value}"
    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(merchant[:id].to_i).to eq(merchant_1.id)
    expect(merchant[:id].to_i).to_not eq(merchant_2.id)
    expect(merchant[:id].to_i).to_not eq(merchant_3.id)
    expect(merchant[:attributes][:name].downcase).to include(value_1.downcase)
  end

  scenario "searches using created_at" do
    attribute = "created_at"
    search_merchant = create(:merchant)
    value = "Oct"

    get "/api/v1/merchants/find?#{attribute}=#{value}"
    expect(response).to be_successful
    returned_merchant = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(returned_merchant[:id].to_i).to eq(search_merchant.id)
  end

  scenario "searches using updated_at" do
    attribute = "updated_at"
    search_merchant = create(:merchant)
    value = "19"

    get "/api/v1/merchants/find?#{attribute}=#{value}"
    expect(response).to be_successful
    returned_merchant = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(returned_merchant[:id].to_i).to eq(search_merchant.id)
  end
end
