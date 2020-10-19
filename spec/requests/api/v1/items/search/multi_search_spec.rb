require 'rails_helper'

describe "it can search by keywords for a multiple items:" do
  scenario "searches for name matches that are case insensitive" do
    attribute = "name"
    value = "ocarina"
    item_1 = create(:item, name: "The Ocarina of Time")
    item_2 = create(:item, name: "Time Stops for Now Woman")
    item_3 = create(:item, name: "Ocarina Blues")

    get "/api/v1/items/find_all?#{attribute}=#{value}"
    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(items.count).to eq(2)
    items.each do |item|
      expect(item[:id].to_i).to eq(item_1.id).or(eq item_3.id)
      expect(item[:id].to_i).to_not eq(item_2.id)
      expect(item[:attributes][:name].downcase).to include(value.downcase)
    end
  end

  scenario "searches for description matches that are case insensitive" do
    attribute = "description"
    value = "dragon"
    item_1 = create(:item, description: "apple banana cheddar dragonfruit")
    item_2 = create(:item, description: "jargon dragon grabbon flagon speakon")
    item_3 = create(:item, description: "There is no dragon here")
    item_4 = create(:item, description: "OKAY SERIOUSLY THIS TIME")

    get "/api/v1/items/find_all?#{attribute}=#{value}"
    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(items.count).to eq(3)
    items.each do |item|
      expect(item[:id].to_i).to eq(item_1.id).or(eq item_2.id).or(eq item_3.id)
      expect(item[:id].to_i).to_not eq(item_4.id)
      expect(item[:attributes][:name].downcase).to include(value.downcase)
    end
  end

  scenario "searches for unit price matches that are partial" do
    attribute = "unit_price"
    value = 99
    item_1 = create(:item, unit_price: 99.13)
    item_2 = create(:item, unit_price: 11.99)
    item_3 = create(:item, unit_price: 80.13)

    get "/api/v1/items/find_all?#{attribute}=#{value}"
    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(items.count).to eq(3)
    items.each do |item|
      expect(item[:id].to_i).to eq(item_1.id).or(eq item_2.id)
      expect(item[:id].to_i).to_not eq(item_3.id)
      expect(returned_item[:attributes][:unit_price].to_s).to include(value.to_s)
    end
  end

  scenario "searches for partial matches that are case insensitive" do
    attribute = "name"
    value = "ill"
    item_1 = create(:item, name: "Schiller")
    item_2 = create(:item, name: "Tillman Group")
    item_3 = create(:item, name: "Williamson Group")

    get "/api/v1/items/find_all?#{attribute}=#{value}"
    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(items.count).to eq(3)
    items.each do |item|
      expect(item[:id].to_i).to eq(item_1.id).or(eq item_2.id).or(eq item_3.id)
      expect(item[:attributes][:name].downcase).to include(value.downcase)
    end
  end

  scenario "searches using created_at" do
    attribute = "created_at"
    create_list(:item, 4)
    value = "Oct"

    get "/api/v1/items/find_all?#{attribute}=#{value}"
    expect(response).to be_successful

    returned_items = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(returned_items.count).to eq(4)
  end

  scenario "searches using updated_at" do
    attribute = "updated_at"
    create_list(:item, 3)
    value = "19"

    get "/api/v1/items/find_all?#{attribute}=#{value}"
    expect(response).to be_successful

    returned_items = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(returned_items.count).to eq(3)
  end
end
