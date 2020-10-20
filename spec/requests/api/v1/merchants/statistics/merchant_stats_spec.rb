require 'rails_helper'

describe "Merchant Business Intelligence Endpoints:" do
  scenario "returns a variable number of merchants ranked by total revenue" do
    #
    # Testing after visualing modeling and predicting on paper
    #   Figuring out how to join my two sets
    #   rails c
    #     puts Merchant.joins(Invoice.joins(:invoice_items, :transactions)).to_sql
    #
    #     puts Merchant.joins(invoices: [:invoice_items, :transactions]).to_sql
    #   rails db
    #     SELECT "invoices".* FROM "invoices" INNER JOIN "invoice_items" ON "invoice_items"."invoice_id" = "invoices"."id" INNER JOIN "transactions" ON "transactions"."invoice_id" = "invoices"."id";
    #
    #     SELECT "merchants".* FROM "merchants" INNER JOIN "invoices" ON "invoices"."merchant_id" = "merchants"."id" INNER JOIN "invoice_items" ON "invoice_items"."invoice_id" = "invoices"."id" INNER JOIN "transactions" ON "transactions"."invoice_id" = "invoices"."id";
    #
    #   Figuring out how to tack on our success condition
    #   rails c
    #     puts Merchant.joins(invoices: [:invoice_items, :transactions]).where(transactions: {result: "success"}).to_sql
    #   rails db
    #     SELECT "merchants".* FROM "merchants" INNER JOIN "invoices" ON "invoices"."merchant_id" = "merchants"."id" INNER JOIN "invoice_items" ON "invoice_items"."invoice_id" = "invoices"."id" INNER JOIN "transactions" ON "transactions"."invoice_id" = "invoices"."id" WHERE "transactions"."result" = 'success';
    #
    #   Figuring out how to tack on grouping
    #   rails c
    #     puts Merchant.joins(invoices: [:invoice_items, :transactions]).where(transactions: {result: "success"}).group(:id).to_sql
    #   rails db
    #     SELECT "merchants".* FROM "merchants" INNER JOIN "invoices" ON "invoices"."merchant_id" = "merchants"."id" INNER JOIN "invoice_items" ON "invoice_items"."invoice_id" = "invoices"."id" INNER JOIN "transactions" ON "transactions"."invoice_id" = "invoices"."id" WHERE "transactions"."result" = 'success' GROUP BY "merchants"."id";
    #
    #   Figuring out selecting with sum/revenue calculation and ordering by
    #   rails c
    #     puts Merchant.select("merchants.*").joins(invoices: [:invoice_items, :transactions]).where(transactions: {result: "success"}).group(:id).to_sql
    #
    #     puts Merchant.select("merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue").joins(invoices: [:invoice_items, :transactions]).where(transactions: {result: "success"}).group(:id).to_sql
    #
    #     puts Merchant.select("merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue").joins(invoices: [:invoice_items, :transactions]).where(transactions: {result: "success"}).group(:id).order('revenue DESC').to_sql
    #   rails db
    #     SELECT merchants.* FROM "merchants" INNER JOIN "invoices" ON "invoices"."merchant_id" = "merchants"."id" INNER JOIN "invoice_items" ON "invoice_items"."invoice_id" = "invoices"."id" INNER JOIN "transactions" ON "transactions"."invoice_id" = "invoices"."id" WHERE "transactions"."result" = 'success' GROUP BY "merchants"."id";
    #
    #     SELECT merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue FROM "merchants" INNER JOIN "invoices" ON "invoices"."merchant_id" = "merchants"."id" INNER JOIN "invoice_items" ON "invoice_items"."invoice_id" = "invoices"."id" INNER JOIN "transactions" ON "transactions"."invoice_id" = "invoices"."id" WHERE "transactions"."result" = 'success' GROUP BY "merchants"."id";
    #
    #     SELECT merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue FROM "merchants" INNER JOIN "invoices" ON "invoices"."merchant_id" = "merchants"."id" INNER JOIN "invoice_items" ON "invoice_items"."invoice_id" = "invoices"."id" INNER JOIN "transactions" ON "transactions"."invoice_id" = "invoices"."id" WHERE "transactions"."result" = 'success' GROUP BY "merchants"."id" ORDER BY revenue DESC;
    #
    # Converting ActiveRecord to Model Method
    #   Merchant Model
    #     def self.most_revenue(limit)
    #       select("merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue")
    #         .joins(invoices: [:invoice_items, :transactions])
    #         .where(transactions: {result: "success"})
    #         .group(:id)
    #         .order('revenue DESC')
    #         .limit(limit)
    #     end
    #
    #   Transaction Model
    #     default_scope { order(id: :asc) }
    #     scope :successful, -> { where(result: "success") }
    #
    #   Merchant Model
    #     def self.most_revenue(limit)
    #       select("merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue")
    #         .joins(invoices: [:invoice_items, :transactions])
    #         .merge(Transaction.unscope.successful)
    #         .group(:id)
    #         .order('revenue DESC')
    #         .limit(limit)
    #     end
    # Update for typo (unscope to unscoped, singular unscope is allowed, but you pass an argument of what to unscope instead of defaulting to everything above the scope you are actually calling)
    # Update for second check on Invoice result = "shipped"
    #   Merchant Model
    #     def self.most_revenue(quantity)
    #       select("merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue")
    #         .joins(invoices: [:invoice_items, :transactions])
    #         .merge(Transaction.unscoped.successful)
    #         .merge(Invoice.unscoped.successful)
    #         .group(:id)
    #         .order('revenue DESC')
    #         .limit(quantity)
    #     end

    # Top 3
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    merchant_3 = create(:merchant)

    # Bottom 2
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
end
