require 'rails_helper'

describe "Relationships - return the merchant associated with an item" do
  it "can get the merchant for an item" do
    merchant_1 = create(:merchant)
    item_1 = create(:item, merchant_id: "#{merchant_1.id}")
    item_2 = create(:item, merchant_id: "#{merchant_1.id}")
    merchant_2 = create(:merchant)
    item_3 = create(:item, merchant_id: "#{merchant_2.id}")

    get "/api/v1/items/#{item_1.id}/merchant"
    expect(response).to be_successful
    merchant = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to be_a(String)
    expect(merchant[:id]).to eq("#{merchant_1.id}")
    expect(merchant[:id]).to_not eq("#{merchant_2.id}")

    expect(merchant).to have_key(:type)
    expect(merchant[:type]).to eq("merchant")

    expect(merchant[:attributes]).to have_key(:name)
    expect(merchant[:attributes][:name]).to be_a(String)
    expect(merchant[:attributes][:name]).to eq(merchant_1.name)
    expect(merchant[:attributes][:name]).to_not eq(merchant_2.name)

    expect(merchant[:attributes]).to have_key(:created_at)
    expect(merchant[:attributes][:created_at]).to be_a(String)

    expect(merchant[:attributes]).to have_key(:updated_at)
    expect(merchant[:attributes][:updated_at]).to be_a(String)

    get "/api/v1/items/#{item_2.id}/merchant"
    expect(response).to be_successful
    merchant = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(merchant[:id]).to eq("#{merchant_1.id}")
    expect(merchant[:id]).to_not eq("#{merchant_2.id}")

    get "/api/v1/items/#{item_3.id}/merchant"
    expect(response).to be_successful
    merchant = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(merchant[:id]).to eq("#{merchant_2.id}")
    expect(merchant[:id]).to_not eq("#{merchant_1.id}")
  end
end
