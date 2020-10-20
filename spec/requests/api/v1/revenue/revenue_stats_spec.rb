require 'rails_helper'

describe "Revenue Business Intelligence Endpoints:" do
  scenario "returns the total revenue across all merchants between the given dates." do
    # This is not an index or show action, it might be a total action
    #
    # Active Record Dreaming
    #   To get to revenue - merchants to invoices to invoice_items(contains rev calc & where condition) and transactions(contains where condition)
    #   To select by dates - which table(s) provide a created/updated that we want to call upon
    #     - I dont think merchants creation helps us
    #     - Invoice creation? updation?
    #   After testing in rails c and rails db... do I really need to go through merchants to call the totes revenue? It just needs to be invoice.status="shipped" and transactions.result="success" that can then SUM invoice_items.quantity*invoice_items.unit_price
    #
    # Finalized rails c and rails db attempt
    #   puts Invoice.joins(:invoice_items, :transactions).where(status: "shipped").where(transactions: {result: "success"}).where(created_at: Date.parse('2012-03-21').beginning_of_day..Date.parse('2012-03-27').end_of_day).sum('invoice_items.quantity * invoice_items.unit_price')
    #
    #   SELECT SUM(invoice_items.quantity * invoice_items.unit_price) FROM "invoices" INNER JOIN "invoice_items" ON "invoice_items"."invoice_id" = "invoices"."id" INNER JOIN "transactions" ON "transactions"."invoice_id" = "invoices"."id" WHERE "invoices"."status" = $1 AND "transactions"."result" = $2 AND "invoices"."created_at" BETWEEN $3 AND $4  [["status", "shipped"], ["result", "success"], ["created_at", "2012-03-21 00:00:00"], ["created_at", "2012-03-27 23:59:59.999999"]];
    #
    # Revenue (This is not a model... is it a PORO?) Method Creation with updates for scope and passed arguments
    #   def total_revenue(start_date, end_date)
    #     Invoice.joins(:invoice_items, :transactions)
    #       .merge(Transaction.unscoped.successful)
    #       .merge(Invoice.unscoped.successful)
    #       .where(created_at: Date.parse(start_date.to_s).beginning_of_day..Date.parse(end_date.to_s).end_of_day)
    #       .sum('invoice_items.quantity * invoice_items.unit_price')
    #   end
    #
    # # FACTORY CREATION
    #   I need merchants, invoices, invoice_items, and transactions
    #   I must include unit_prices and quantities so that I can calculate total revenue myself
    #   Keep it simple and borrow and edit from the merchant statistics spec
    #     - Make it even simpler and only have 3 total merchants
    #     - Each merchant only has 2 invoices (with 1 transaction "success" the other "failed")
    #     - Unit price = 100
    #     - Quantity = 1
    #
    # EXAMPLE JSON RESPONSE FOR SERIALIZER
    # {
    #   "data": {
    #     "id": null,
    #     "attributes": {
    #       "revenue"  : 43201227.8000003
    #     }
    #   }
    # }

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

    # Since only 3 invoices are successful
    # They each bring in 100
    expected_revenue = 300.00

    # Api and finish the test
    start_date = '2020-03-09'
    end_date = '2020-03-24'
    get "/api/v1/revenue?start=#{start_date}&end=#{end_date}"

    expect(response).to be_successful
    result = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(result[:id]).to be_null
    expect(result[:attributes][:revenue]).to eq(expected_revenue)
  end

  scenario "returns the total revenue for a single merchant" do
    # This seems like a show action
  end
end
