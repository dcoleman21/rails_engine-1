require 'rails_helper'

describe "Relationships - return all items associated with a merchant" do
  it "can get all items for a merchant" do
    id = create(:merchant).id
    create_list(:item, 5)
    create_list(:item, 5, merchant_id: "#{id}")

    get "/api/v1/merchants/#{id}/items"

    expect(response).to be_successful
    items = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(Item.all.count).to eq(10)
    expect(items.count).to eq(5)

    items.each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)

      expect(item).to have_key(:type)
      expect(item[:type]).to eq("item")

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_an(Integer)

      expect(item[:attributes]).to have_key(:created_at)
      expect(item[:attributes][:created_at]).to be_a(String)

      expect(item[:attributes]).to have_key(:updated_at)
      expect(item[:attributes][:updated_at]).to be_a(String)
    end
  end
end
