require 'rails_helper'

describe "Merchant Business Intelligence Endpoints:" do
  scenario "returns a variable number of merchants ranked by total revenue" do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    merchant_3 = create(:merchant)
    merchant_4 = create(:merchant)
    merchant_5 = create(:merchant)

    invoice_1 = create(:invoice, merchant_id: merchant_1.id)
    create(:transaction, result: "success", invoice_id: invoice_1.id)
    create(:invoice_item, quantity: 20, unit_price: 100.00, invoice_id: invoice_1.id, item_id: create(:item, unit_price: 100.00).id)

    invoice_2 = create(:invoice, merchant_id: merchant_2.id)
    create(:transaction, result: "success", invoice_id: invoice_2.id)
    create(:invoice_item, quantity: 15, unit_price: 100.00, invoice_id: invoice_2.id, item_id: create(:item, unit_price: 100.00).id)

    invoice_3 = create(:invoice, merchant_id: merchant_3.id)
    create(:transaction, result: "success", invoice_id: invoice_3.id)
    create(:invoice_item, quantity: 10, unit_price: 100.00, invoice_id: invoice_3.id, item_id: create(:item, unit_price: 100.00).id)

    invoice_4 = create(:invoice, merchant_id: merchant_4.id)
    create(:transaction, result: "success", invoice_id: invoice_4.id)
    create(:invoice_item, quantity: 5, unit_price: 100.00, invoice_id: invoice_4.id, item_id: create(:item, unit_price: 100.00).id)

    invoice_5 = create(:invoice, merchant_id: merchant_5.id)
    create(:transaction, result: "success", invoice_id: invoice_5.id)
    create(:invoice_item, quantity: 1, unit_price: 100.00, invoice_id: invoice_5.id, item_id: create(:item, unit_price: 100.00).id)

    invoice_6 = create(:invoice, merchant_id: merchant_1.id)
    create(:transaction, result: "failed", invoice_id: invoice_6.id)
    create(:invoice_item, invoice_id: invoice_6.id)

    invoice_7 = create(:invoice, merchant_id: merchant_2.id)
    create(:transaction, result: "failed", invoice_id: invoice_7.id)
    create(:invoice_item, invoice_id: invoice_7.id)

    invoice_8 = create(:invoice, merchant_id: merchant_3.id)
    create(:transaction, result: "failed", invoice_id: invoice_8.id)
    create(:invoice_item, invoice_id: invoice_8.id)

    quantity = 3
    get "/api/v1/merchants/most_revenue?quantity=#{quantity}"

    expect(response).to be_successful
    results = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(results.count).to eq(quantity)

    results.each do |result|
      expect(result[:type]).to eq("merchant")

      expect(result[:id].to_i).to eq(merchant_1.id).or(eq merchant_2.id).or(eq merchant_3.id)
      expect(result[:id].to_i).to_not eq(merchant_4.id)
      expect(result[:id].to_i).to_not eq(merchant_5.id)

    end
  end

  scenario "returns a variable number of merchants ranked by total number of items sold" do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    merchant_3 = create(:merchant)
    merchant_4 = create(:merchant)
    merchant_5 = create(:merchant)

    invoice_1 = create(:invoice, merchant_id: merchant_1.id)
    create(:transaction, result: "success", invoice_id: invoice_1.id)
    create(:invoice_item, quantity: 20, unit_price: 100.00, invoice_id: invoice_1.id, item_id: create(:item, unit_price: 100.00).id)

    invoice_2 = create(:invoice, merchant_id: merchant_2.id)
    create(:transaction, result: "success", invoice_id: invoice_2.id)
    create(:invoice_item, quantity: 15, unit_price: 100.00, invoice_id: invoice_2.id, item_id: create(:item, unit_price: 100.00).id)

    invoice_3 = create(:invoice, merchant_id: merchant_3.id)
    create(:transaction, result: "success", invoice_id: invoice_3.id)
    create(:invoice_item, quantity: 10, unit_price: 100.00, invoice_id: invoice_3.id, item_id: create(:item, unit_price: 100.00).id)

    invoice_4 = create(:invoice, merchant_id: merchant_4.id)
    create(:transaction, result: "success", invoice_id: invoice_4.id)
    create(:invoice_item, quantity: 5, unit_price: 100.00, invoice_id: invoice_4.id, item_id: create(:item, unit_price: 100.00).id)

    invoice_5 = create(:invoice, merchant_id: merchant_5.id)
    create(:transaction, result: "success", invoice_id: invoice_5.id)
    create(:invoice_item, quantity: 1, unit_price: 100.00, invoice_id: invoice_5.id, item_id: create(:item, unit_price: 100.00).id)

    invoice_6 = create(:invoice, merchant_id: merchant_1.id)
    create(:transaction, result: "failed", invoice_id: invoice_6.id)
    create(:invoice_item, invoice_id: invoice_6.id)

    invoice_7 = create(:invoice, merchant_id: merchant_2.id)
    create(:transaction, result: "failed", invoice_id: invoice_7.id)
    create(:invoice_item, invoice_id: invoice_7.id)

    invoice_8 = create(:invoice, merchant_id: merchant_3.id)
    create(:transaction, result: "failed", invoice_id: invoice_8.id)
    create(:invoice_item, invoice_id: invoice_8.id)

    quantity = 2
    get "/api/v1/merchants/most_items?quantity=#{quantity}"

    expect(response).to be_successful
    results = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(results.count).to eq(quantity)

    results.each do |result|
      expect(result[:type]).to eq("merchant")

      expect(result[:id].to_i).to eq(merchant_1.id).or(eq merchant_2.id)
      expect(result[:id].to_i).to_not eq(merchant_3.id)
      expect(result[:id].to_i).to_not eq(merchant_4.id)
      expect(result[:id].to_i).to_not eq(merchant_5.id)

    end
  end
end
