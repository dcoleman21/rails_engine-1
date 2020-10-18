# Spec Harness ReST endpoints Merchants can get all merchants
#      Failure/Error: expect(json[:data].length).to eq(100)
#
#      TypeError:
#        no implicit conversion of Symbol into Integer
#      # ./spec/features/harness_spec.rb:134:in `block (4 levels) in <top (required)>'

require 'rails_helper'

describe "Merchants API" do
  it "sends a list of merchants" do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants.count).to eq(3)

    merchants.each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an(Integer)

      expect(merchant).to have_key(:name)
      expect(merchant[:name]).to be_an(String)

      expect(merchant).to have_key(:created_at)
      expect(merchant[:created_at]).to be_an(String)

      expect(merchant).to have_key(:updated_at)
      expect(merchant[:updated_at]).to be_an(String)
    end
  end
end
