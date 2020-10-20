require 'rails_helper'

describe "Practice Advanced Active Record Lesson:" do
  scenario "returns the 5 more expensive invoices that have successful transactions" do
    invoice_1 = create(:invoice)
    create(:transaction, result: "success", invoice_id: invoice_1.id)
    create(:invoice_item, unit_price: 10.99, quantity: 4, invoice_id: invoice_1.id)
    create(:invoice_item, unit_price: 25.00, quantity: 3, invoice_id: invoice_1.id)
    create(:invoice_item, unit_price: 3.45, quantity: 2, invoice_id: invoice_1.id)

    invoice_2 = create(:invoice)
    create(:transaction, result: "success", invoice_id: invoice_2.id)
    create(:invoice_item, unit_price: 24.78, quantity: 100, invoice_id: invoice_2.id)
    create(:invoice_item, unit_price: 99.00, quantity: 20, invoice_id: invoice_2.id)

    invoice_3 = create(:invoice)
    create(:transaction, result: "success", invoice_id: invoice_3.id)
    create(:invoice_item, unit_price: 48.45, quantity: 5, invoice_id: invoice_3.id)
    create(:invoice_item, unit_price: 367.25, quantity: 2, invoice_id: invoice_3.id)
    create(:invoice_item, unit_price: 1.45, quantity: 20, invoice_id: invoice_3.id)
    create(:invoice_item, unit_price: 764.24, quantity: 1, invoice_id: invoice_3.id)

    invoice_4 = create(:invoice)
    create(:transaction, result: "success", invoice_id: invoice_4.id)
    create(:invoice_item, unit_price: 456.89, quantity: 1, invoice_id: invoice_4.id)

    invoice_5 = create(:invoice)
    create(:transaction, result: "success", invoice_id: invoice_5.id)
    create(:invoice_item, unit_price: 45.78, quantity: 3, invoice_id: invoice_5.id)
    create(:invoice_item, unit_price: 35.46, quantity: 5, invoice_id: invoice_5.id)
    create(:invoice_item, unit_price: 29.56, quantity: 7, invoice_id: invoice_5.id)

    invoice_9 = create(:invoice)
    create(:transaction, result: "success", invoice_id: invoice_9.id)
    create(:invoice_item, unit_price: 1, quantity: 1, invoice_id: invoice_9.id)

    invoice_10 = create(:invoice)
    create(:transaction, result: "success", invoice_id: invoice_10.id)
    create(:invoice_item, unit_price: 1, quantity: 1, invoice_id: invoice_10.id)
    create(:invoice_item, unit_price: 1, quantity: 1, invoice_id: invoice_10.id)
    create(:invoice_item, unit_price: 1, quantity: 1, invoice_id: invoice_10.id)

    invoice_11 = create(:invoice)
    create(:transaction, result: "success", invoice_id: invoice_11.id)
    create(:invoice_item, unit_price: 1, quantity: 1, invoice_id: invoice_11.id)
    create(:invoice_item, unit_price: 1, quantity: 1, invoice_id: invoice_11.id)
    create(:invoice_item, unit_price: 1, quantity: 1, invoice_id: invoice_11.id)
    create(:invoice_item, unit_price: 1, quantity: 1, invoice_id: invoice_11.id)

    invoice_12 = create(:invoice)
    create(:transaction, result: "success", invoice_id: invoice_12.id)
    create(:invoice_item, unit_price: 1, quantity: 1, invoice_id: invoice_12.id)

    invoice_6 = create(:invoice)
    create(:transaction, result: "failed", invoice_id: invoice_6.id)
    create(:invoice_item, invoice_id: invoice_6.id)
    create(:invoice_item, invoice_id: invoice_6.id)
    create(:invoice_item, invoice_id: invoice_6.id)

    invoice_7 = create(:invoice)
    create(:transaction, result: "failed", invoice_id: invoice_7.id)
    create(:invoice_item, invoice_id: invoice_7.id)
    create(:invoice_item, invoice_id: invoice_7.id)

    invoice_8 = create(:invoice)
    create(:transaction, result: "failed", invoice_id: invoice_8.id)
    create(:invoice_item, invoice_id: invoice_8.id)
    create(:invoice_item, invoice_id: invoice_8.id)
    create(:invoice_item, invoice_id: invoice_8.id)
    create(:invoice_item, invoice_id: invoice_8.id)

    quantity = 5
    get "/api/v1/invoices/most_expensive?quantity=#{quantity}"

    expect(response).to be_successful
    top_five = JSON.parse(response.body, symbolize_names: true)

    top_five.each do |result|
      expect(result[:id]).to eq(invoice_1.id).or(eq invoice_2.id).or(eq invoice_3.id).or(eq invoice_4.id).or(eq invoice_5.id)
      expect(result[:id]).to_not eq(invoice_6.id)
      expect(result[:id]).to_not eq(invoice_7.id)
      expect(result[:id]).to_not eq(invoice_8.id)
      expect(result[:id]).to_not eq(invoice_9.id)
      expect(result[:id]).to_not eq(invoice_10.id)
      expect(result[:id]).to_not eq(invoice_11.id)
      expect(result[:id]).to_not eq(invoice_12.id)
    end
  end
end
