require 'rails_helper'

describe "Items API" do
  scenario "sends a list of items" do
    create_list(:item, 5)

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(5)

    items[:data].each do |item|
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

  scenario "can get one item by its id" do
    id = create(:item).id

    get "/api/v1/items/#{id}"

    item = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful

    expect(item).to have_key(:id)
    expect(item[:id]).to be_a(String)

    expect(item).to have_key(:type)
    expect(item[:type]).to eq("item")

    expect(item[:attributes]).to have_key(:name)
    expect(item[:attributes][:name]).to be_a(String)

    expect(item[:attributes]).to have_key(:created_at)
    expect(item[:attributes][:created_at]).to be_a(String)

    expect(item[:attributes]).to have_key(:updated_at)
    expect(item[:attributes][:updated_at]).to be_a(String)
  end

  scenario "can get an error if id doesn't exist" do
    get "/api/v1/items/1"
    expect(response).to_not be_successful
    expect(response.status).to eq(404)
  end

  scenario "can create a new item" do
    merchant = create(:merchant)
    item_params = {
      name: "name",
      description: "This is a chunk of information that is supposed to be 256 characters or longer since that is the limit of a String data type in Active Record and this particular record allows for a Text data type which allows for up to 30,000 characters saved. This allows our CSV doc to send and save longer descriptions.",
      unit_price: 300.98,
      merchant_id: merchant.id,
      created_at: "create",
      updated_at: "update"
    }

    post "/api/v1/items", params: item_params
    created_item = Item.last

    expect(response).to be_successful
    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.merchant_id).to eq(merchant.id)
  end

  scenario "can destroy a item" do
    item = create(:item)

    expect{ delete "/api/v1/items/#{item.id}" }.to change(Item, :count).by(-1)

    expect(response).to be_successful
    expect(response.status).to eq(204)
    expect(response.body).to be_empty
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  scenario "can update an existing item" do
    id = create(:item).id
    previous_name = Item.last.name
    previous_description = Item.last.description
    previous_unit_price = Item.last.unit_price
    item_params = {
      name: "NEW ITEM NAME",
      description: "This is a chunk of information that is supposed to be 256 characters or longer since that is the limit of a String data type in Active Record and this particular record allows for a Text data type which allows for up to 30,000 characters saved. This allows our CSV doc to send and save longer descriptions.",
      unit_price: 1245.98,
    }

    patch "/api/v1/items/#{id}", params: item_params
    expect(response).to be_successful

    item = Item.find_by(id: id)
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq(item_params[:name])

    expect(item.description).to_not eq(previous_description)
    expect(item.description).to eq(item_params[:description])

    expect(item.unit_price).to_not eq(previous_unit_price)
    expect(item.unit_price).to eq(item_params[:unit_price])
  end
end
