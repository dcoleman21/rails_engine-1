require 'rails_helper'

describe "it can search by keywords for a multiple merchants:" do
  scenario "searches for matches that are case insensitive" do
    attribute = "name"
    value = "ocarina"
    merchant_1 = create(:merchant, name: "The Ocarina of Time")
    merchant_2 = create(:merchant, name: "Time Stops for Now Woman")
    merchant_3 = create(:merchant, name: "Ocarina Blues")

    get "/api/v1/merchants/find_all?#{attribute}=#{value}"
    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(merchants.count).to eq(2)
    merchants.each do |merchant|
      expect(merchant[:id].to_i).to eq(merchant_1.id).or(eq merchant_3.id)
      expect(merchant[:id].to_i).to_not eq(merchant_2.id)
      expect(merchant[:attributes][:name].downcase).to include(value.downcase)
    end
  end

  scenario "searches for partial matches that are case insensitive" do
    attribute = "name"
    value = "ill"
    merchant_1 = create(:merchant, name: "Schiller")
    merchant_2 = create(:merchant, name: "Tillman Group")
    merchant_3 = create(:merchant, name: "Williamson Group")

    get "/api/v1/merchants/find_all?#{attribute}=#{value}"
    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(merchants.count).to eq(3)
    merchants.each do |merchant|
      expect(merchant[:id].to_i).to eq(merchant_1.id).or(eq merchant_2.id).or(eq merchant_3.id)
      expect(merchant[:attributes][:name].downcase).to include(value.downcase)
    end
  end

  scenario "searches using created_at" do
    attribute = "created_at"
    create_list(:merchant, 4)
    value = "Oct"

    get "/api/v1/merchants/find_all?#{attribute}=#{value}"
    expect(response).to be_successful

    returned_merchants = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(returned_merchants.count).to eq(4)
  end

  scenario "searches using updated_at" do
    attribute = "updated_at"
    create_list(:merchant, 3)
    value = "19"

    get "/api/v1/merchants/find_all?#{attribute}=#{value}"
    expect(response).to be_successful

    returned_merchants = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(returned_merchants.count).to eq(3)
  end
end
