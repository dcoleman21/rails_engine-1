require 'rails_helper'

describe "it can search by keywords for a single item:" do
  scenario "searches for name matches that are case insensitive" do
    attribute = "name"
    value = "ocarina"
    item_1 = create(:item, name: "The Ocarina of Time")
    item_2 = create(:item, name: "Time Stops for Now Woman")

    get "/api/v1/items/find?#{attribute}=#{value}"
    expect(response).to be_successful

    returned_item = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(returned_item[:id].to_i).to eq(item_1.id)
    expect(returned_item[:id].to_i).to_not eq(item_2.id)
    expect(returned_item[:attributes][:name].downcase).to include(value.downcase)
  end

  scenario "searches for description matches that are case insensitive" do
    attribute = "description"
    value = "dragon"
    item_1 = create(:item, description: "apple banana cheddar dragonfruit")
    item_2 = create(:item, description: "jargon dragon grabbon flagon speakon")

    get "/api/v1/items/find?#{attribute}=#{value}"
    expect(response).to be_successful

    returned_item = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(returned_item[:id].to_i).to eq(item_1.id)
    expect(returned_item[:id].to_i).to_not eq(item_2.id)
    expect(returned_item[:attributes][:description].downcase).to include(value.downcase)
  end

  scenario "searches for unit price matches that are partial" do
    attribute = "unit_price"
    value = 99
    item_1 = create(:item, unit_price: 99.13)
    item_2 = create(:item, unit_price: 11.99)

    get "/api/v1/items/find?#{attribute}=#{value}"
    expect(response).to be_successful

    returned_item = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(returned_item[:id].to_i).to eq(item_1.id)
    expect(returned_item[:id].to_i).to_not eq(item_2.id)
    expect(returned_item[:attributes][:unit_price].to_s).to include(value.to_s)
  end

  scenario "searches for partial matches that are case insensitive" do
    attribute = "name"
    value = "ill"
    item_1 = create(:item, name: "Schiller")
    item_2 = create(:item, name: "Tillman Group")

    get "/api/v1/items/find?#{attribute}=#{value}"
    expect(response).to be_successful

    returned_item = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(returned_item[:id].to_i).to eq(item_1.id)
    expect(returned_item[:id].to_i).to_not eq(item_2.id)
    expect(returned_item[:attributes][:name].downcase).to include(value.downcase)
  end

  scenario "searches using created_at" do
    attribute = "created_at"
    search_item = create(:item)
    value = "Oct"

    get "/api/v1/items/find?#{attribute}=#{value}"
    expect(response).to be_successful
    returned_item = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(returned_item[:id].to_i).to eq(search_item.id)
  end

  scenario "searches using updated_at" do
    attribute = "updated_at"
    search_item = create(:item)
    value = "19"

    get "/api/v1/items/find?#{attribute}=#{value}"
    expect(response).to be_successful
    returned_item = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(returned_item[:id].to_i).to eq(search_item.id)
  end
end
