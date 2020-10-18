require 'rails_helper'

describe "Merchants API" do
  it "sends a list of merchants" do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(3)

    merchants[:data].each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an(Integer)

      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to eq("merchant")

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_an(String)

      expect(merchant[:attributes]).to have_key(:created_at)
      expect(merchant[:attributes][:created_at]).to be_an(String)

      expect(merchant[:attributes]).to have_key(:updated_at)
      expect(merchant[:attributes][:updated_at]).to be_an(String)
    end
  end
end
