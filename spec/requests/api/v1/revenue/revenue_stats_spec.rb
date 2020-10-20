require 'rails_helper'

describe "Revenue Business Intelligence Endpoints:" do
  scenario "returns the total revenue across all merchants between the given dates." do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    merchant_3 = create(:merchant)

    invoice_1 = create(:invoice, merchant_id: merchant_1.id)
    create(:transaction, result: "success", invoice_id: invoice_1.id)
    create(:invoice_item, quantity: 1, unit_price: 100.00, invoice_id: invoice_1.id, item_id: create(:item, unit_price: 100.00).id)

    invoice_2 = create(:invoice, merchant_id: merchant_1.id)
    create(:transaction, result: "failed", invoice_id: invoice_2.id)
    create(:invoice_item, quantity: 1, unit_price: 100.00, invoice_id: invoice_2.id, item_id: create(:item, unit_price: 100.00).id)

    invoice_3 = create(:invoice, merchant_id: merchant_2.id)
    create(:transaction, result: "success", invoice_id: invoice_3.id)
    create(:invoice_item, quantity: 1, unit_price: 100.00, invoice_id: invoice_3.id, item_id: create(:item, unit_price: 100.00).id)

    invoice_4 = create(:invoice, merchant_id: merchant_2.id)
    create(:transaction, result: "failed", invoice_id: invoice_4.id)
    create(:invoice_item, quantity: 1, unit_price: 100.00, invoice_id: invoice_4.id, item_id: create(:item, unit_price: 100.00).id)

    invoice_5 = create(:invoice, merchant_id: merchant_3.id)
    create(:transaction, result: "success", invoice_id: invoice_5.id)
    create(:invoice_item, quantity: 1, unit_price: 100.00, invoice_id: invoice_5.id, item_id: create(:item, unit_price: 100.00).id)

    invoice_6 = create(:invoice, merchant_id: merchant_3.id)
    create(:transaction, result: "failed", invoice_id: invoice_6.id)
    create(:invoice_item, quantity: 1, unit_price: 100.00, invoice_id: invoice_6.id, item_id: create(:item, unit_price: 100.00).id)

    expected_revenue = 300.00

    start_date = Date.today
    end_date = Date.today
    get "/api/v1/revenue?start=#{start_date}&end=#{end_date}"

    expect(response).to be_successful
    result = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(result[:id]).to be_nil
    expect(result[:attributes][:revenue]).to eq(expected_revenue)
  end

  scenario "returns the total revenue for a single merchant" do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    merchant_3 = create(:merchant)

    invoice_1 = create(:invoice, merchant_id: merchant_1.id)
    create(:transaction, result: "success", invoice_id: invoice_1.id)
    create(:invoice_item, quantity: 1, unit_price: 100.00, invoice_id: invoice_1.id, item_id: create(:item, unit_price: 100.00).id)

    invoice_2 = create(:invoice, merchant_id: merchant_1.id)
    create(:transaction, result: "failed", invoice_id: invoice_2.id)
    create(:invoice_item, quantity: 1, unit_price: 100.00, invoice_id: invoice_2.id, item_id: create(:item, unit_price: 100.00).id)

    invoice_3 = create(:invoice, merchant_id: merchant_2.id)
    create(:transaction, result: "success", invoice_id: invoice_3.id)
    create(:invoice_item, quantity: 1, unit_price: 120.00, invoice_id: invoice_3.id, item_id: create(:item, unit_price: 120.00).id)

    invoice_4 = create(:invoice, merchant_id: merchant_2.id)
    create(:transaction, result: "failed", invoice_id: invoice_4.id)
    create(:invoice_item, quantity: 1, unit_price: 120.00, invoice_id: invoice_4.id, item_id: create(:item, unit_price: 120.00).id)

    invoice_5 = create(:invoice, merchant_id: merchant_3.id)
    create(:transaction, result: "success", invoice_id: invoice_5.id)
    create(:invoice_item, quantity: 1, unit_price: 140.00, invoice_id: invoice_5.id, item_id: create(:item, unit_price: 140.00).id)

    invoice_6 = create(:invoice, merchant_id: merchant_3.id)
    create(:transaction, result: "failed", invoice_id: invoice_6.id)
    create(:invoice_item, quantity: 1, unit_price: 140.00, invoice_id: invoice_6.id, item_id: create(:item, unit_price: 140.00).id)

    merchant_1_rev = 100.00
    merchant_2_rev = 120.00
    merchant_3_rev = 140.00

    get "/api/v1/merchants/#{merchant_1.id}/revenue"

    expect(response).to be_successful
    result = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(result[:id]).to be_nil
    expect(result[:attributes][:revenue]).to eq(merchant_1_rev)
    expect(result[:attributes][:revenue]).to_not eq(merchant_2_rev)
    expect(result[:attributes][:revenue]).to_not eq(merchant_3_rev)
  end
end
