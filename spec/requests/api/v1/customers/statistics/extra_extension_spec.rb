require 'rails_helper'

describe "Extra Extension from Ian:" do
  scenario "returns X number of customers who are repeaters and ordered by highest revenue" do
    customer_1 = create(:customer)
    customer_2 = create(:customer)
    customer_3 = create(:customer)
    customer_4 = create(:customer)
    customer_5 = create(:customer)

    invoice_1 = create(:invoice, customer_id: customer_1.id)
    create(:transaction, result: "success", invoice_id: invoice_1.id)
    create(:invoice_item, quantity: 1, unit_price: 500.00, invoice_id: invoice_1.id, item_id: create(:item, unit_price: 500.00).id)

    invoice_2 = create(:invoice, customer_id: customer_2.id)
    create(:transaction, result: "success", invoice_id: invoice_2.id)
    create(:invoice_item, quantity: 1, unit_price: 400.00, invoice_id: invoice_2.id, item_id: create(:item, unit_price: 400.00).id)

    invoice_3 = create(:invoice, customer_id: customer_3.id)
    create(:transaction, result: "success", invoice_id: invoice_3.id)
    create(:invoice_item, quantity: 1, unit_price: 140.00, invoice_id: invoice_3.id, item_id: create(:item, unit_price: 140.00).id)

    invoice_4 = create(:invoice, customer_id: customer_3.id)
    create(:transaction, result: "success", invoice_id: invoice_4.id)
    create(:invoice_item, quantity: 1, unit_price: 100.00, invoice_id: invoice_4.id, item_id: create(:item, unit_price: 100.00).id)

    invoice_5 = create(:invoice, customer_id: customer_4.id)
    create(:transaction, result: "success", invoice_id: invoice_5.id)
    create(:invoice_item, quantity: 1, unit_price: 160.00, invoice_id: invoice_5.id, item_id: create(:item, unit_price: 160.00).id)

    invoice_6 = create(:invoice, customer_id: customer_4.id)
    create(:transaction, result: "success", invoice_id: invoice_6.id)
    create(:invoice_item, quantity: 1, unit_price: 100.00, invoice_id: invoice_6.id, item_id: create(:item, unit_price: 100.00).id)

    invoice_7 = create(:invoice, customer_id: customer_5.id)
    create(:transaction, result: "success", invoice_id: invoice_7.id)
    create(:invoice_item, quantity: 1, unit_price: 180.00, invoice_id: invoice_7.id, item_id: create(:item, unit_price: 180.00).id)

    invoice_8 = create(:invoice, customer_id: customer_5.id)
    create(:transaction, result: "success", invoice_id: invoice_8.id)
    create(:invoice_item, quantity: 1, unit_price: 100.00, invoice_id: invoice_8.id, item_id: create(:item, unit_price: 100.00).id)


    quantity = 3
    customer_3_revenue = 240.00
    customer_4_revenue = 260.00
    customer_5_revenue = 280.00
    # Should return customer 5, 4, 3 (because they actually repeat) in that order
    get "/api/v1/customers/best_repeaters?quantity=#{quantity}"

    expect(response).to be_successful
    top_3 = JSON.parse(response.body, symbolize_names: true)

    top_3.each do |result|
      expect(result[:id]).to eq(customer_3.id).or(eq customer_4.id).or(eq customer_5.id)
      expect(result[:id]).to_not eq(customer_1.id)
      expect(result[:id]).to_not eq(customer_2.id)
      expect(result[:revenue]).to eq(customer_3_revenue).or(eq customer_4_revenue).or(eq customer_5_revenue)
    end
    
    expect(top_3[0][:revenue]).to eq(customer_5_revenue)
    expect(top_3[1][:revenue]).to eq(customer_4_revenue)
    expect(top_3[2][:revenue]).to eq(customer_3_revenue)
  end
end
