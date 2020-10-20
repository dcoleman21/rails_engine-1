require 'rails_helper'

describe "Revenue Business Intelligence Endpoints:" do
  scenario "returns the total revenue across all merchants between the given dates." do
    # This is not an index or show action, it might be a total action

    # Active Record Dreaming
      To get to revenue - merchants to invoices to invoice_items(contains rev calc & where condition) and transactions(contains where condition)
      To select by dates - which table(s) provide a created/updated that we want to call upon
        - I dont think merchants creation helps us
        - Invoice creation? updation?

    # FACTORY CREATION
      I need merchants, invoices, invoice_items, and transactions
      I must include unit_prices and quantities so that I can calculate total revenue myself
      Keep it simple and borrow and edit from the merchant statistics spec
        - Make it even simpler and only have 3 total merchants
        - Each merchant only has 2 invoices (with 1 transaction "success" the other "failed")
        - Unit price = 100
        - Quantity = 1


    start_date = 2020-03-09
    end_date = 2020-03-24
    get "/api/v1/revenue?start=#{start_date}&end=#{end_date}"

    expect(response).to be_successful

    # EXAMPLE JSON RESPONSE FOR SERIALIZER
    # {
    #   "data": {
    #     "id": null,
    #     "attributes": {
    #       "revenue"  : 43201227.8000003
    #     }
    #   }
    # }
    result = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(results.count).to eq(quantity)

    results.each do |result|
      expect(result[:id]).to be_null
      expect(result[:attributes][:revenue]).to eq(expected_revenue)
    end
  end

  scenario "returns the total revenue for a single merchant" do
    # This seems like a show action
  end
end



# Experimenting in rails c and rails db, this is what I ended with
#
# puts Merchant.select("merchants.*, SUM(invoice_items.quantity) AS quantity_of_items").joins(invoices: [:invoice_items, :transactions]).where(transactions: {result: "success"}).where(invoices: {status: "shipped"}).group(:id).order('quantity_of_items DESC').to_sql
#
# SELECT merchants.*, SUM(invoice_items.quantity) AS quantity_of_items FROM "merchants" INNER JOIN "invoices" ON "invoices"."merchant_id" = "merchants"."id" INNER JOIN "invoice_items" ON "invoice_items"."invoice_id" = "invoices"."id" INNER JOIN "transactions" ON "transactions"."invoice_id" = "invoices"."id" WHERE "transactions"."result" = 'success' AND "invoices"."status" = 'shipped' GROUP BY "merchants"."id" ORDER BY quantity_of_items DESC;
#
# Merchant Method Creation with updates for scopes that exist
#
# def self.most_items(quantity)
#   select("merchants.*, SUM(invoice_items.quantity) AS quantity_of_items")
#     .joins(invoices: [:invoice_items, :transactions])
#     .merge(Transaction.unscoped.successful)
#     .merge(Invoice.unscoped.successful)
#     .group(:id).order('quantity_of_items DESC')
#     .limit(quantity)
# end
