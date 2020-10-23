require 'rails_helper'

describe "Merchants API" do
  scenario "sends a list of merchants" do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(3)

    merchants[:data].each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a(String)

      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to eq("merchant")

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)

      expect(merchant[:attributes]).to have_key(:created_at)
      expect(merchant[:attributes][:created_at]).to be_a(String)

      expect(merchant[:attributes]).to have_key(:updated_at)
      expect(merchant[:attributes][:updated_at]).to be_a(String)
    end
  end

  scenario "can get one merchant by its id" do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful

    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to be_a(String)

    expect(merchant).to have_key(:type)
    expect(merchant[:type]).to eq("merchant")

    expect(merchant[:attributes]).to have_key(:name)
    expect(merchant[:attributes][:name]).to be_a(String)

    expect(merchant[:attributes]).to have_key(:created_at)
    expect(merchant[:attributes][:created_at]).to be_a(String)

    expect(merchant[:attributes]).to have_key(:updated_at)
    expect(merchant[:attributes][:updated_at]).to be_a(String)
  end

  scenario "can get an error if id doesn't exist on show" do
    get "/api/v1/merchants/1"
    expect(response).to_not be_successful
    expect(response.status).to eq(404)
  end

  scenario "can create a new merchant" do
    merchant_params = {
      name: "name",
      created_at: "create",
      updated_at: "update"
    }

    post "/api/v1/merchants", params: merchant_params
    expect(response).to be_successful

    created_merchant = Merchant.last
    expect(created_merchant.name).to eq(merchant_params[:name])
  end

  scenario "can get an error if name is empty on create" do
    merchant_params = {
    }

    post "/api/v1/merchants", params: merchant_params
    expect(response).to_not be_successful
    expect(response.status).to eq(404)
  end

  scenario "can destroy a merchant" do
    merchant = create(:merchant)

    expect{ delete "/api/v1/merchants/#{merchant.id}" }.to change(Merchant, :count).by(-1)

    expect(response).to be_successful
    expect(response.status).to eq(204)
    expect(response.body).to be_empty
    expect{Merchant.find(merchant.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  scenario "can get an error if id doesn't exist on destroy" do
    delete "/api/v1/merchants/1"
    expect(response).to_not be_successful
    expect(response.status).to eq(404)
  end

  scenario "can update an existing merchant" do
    id = create(:merchant).id
    previous_name = Merchant.last.name
    merchant_params = { name: "NEW MERCHANT NAME" }

    patch "/api/v1/merchants/#{id}", params: merchant_params
    expect(response).to be_successful

    merchant = Merchant.find_by(id: id)
    expect(merchant.name).to_not eq(previous_name)
    expect(merchant.name).to eq(merchant_params[:name])
  end
end
