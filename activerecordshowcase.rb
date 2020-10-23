Testing after visualing modeling and predicting on paper

  Figuring out how to join my two sets

    rails c
      puts Merchant.joins(Invoice.joins(:invoice_items, :transactions)).to_sql

      puts Merchant.joins(invoices: [:invoice_items, :transactions]).to_sql

    rails db
      SELECT "invoices".* FROM "invoices" INNER JOIN "invoice_items" ON "invoice_items"."invoice_id" = "invoices"."id" INNER JOIN "transactions" ON "transactions"."invoice_id" = "invoices"."id";

      SELECT "merchants".* FROM "merchants" INNER JOIN "invoices" ON "invoices"."merchant_id" = "merchants"."id" INNER JOIN "invoice_items" ON "invoice_items"."invoice_id" = "invoices"."id" INNER JOIN "transactions" ON "transactions"."invoice_id" = "invoices"."id";

  Figuring out how to tack on our success condition

    rails c
      puts Merchant.joins(invoices: [:invoice_items, :transactions]).where(transactions: {result: "success"}).to_sql

    rails db
      SELECT "merchants".* FROM "merchants" INNER JOIN "invoices" ON "invoices"."merchant_id" = "merchants"."id" INNER JOIN "invoice_items" ON "invoice_items"."invoice_id" = "invoices"."id" INNER JOIN "transactions" ON "transactions"."invoice_id" = "invoices"."id" WHERE "transactions"."result" = 'success';

  Figuring out how to tack on grouping

    rails c
      puts Merchant.joins(invoices: [:invoice_items, :transactions]).where(transactions: {result: "success"}).group(:id).to_sql

    rails db
      SELECT "merchants".* FROM "merchants" INNER JOIN "invoices" ON "invoices"."merchant_id" = "merchants"."id" INNER JOIN "invoice_items" ON "invoice_items"."invoice_id" = "invoices"."id" INNER JOIN "transactions" ON "transactions"."invoice_id" = "invoices"."id" WHERE "transactions"."result" = 'success' GROUP BY "merchants"."id";

  Figuring out selecting with sum/revenue calculation and ordering by

    rails c
      puts Merchant.select("merchants.*").joins(invoices: [:invoice_items, :transactions]).where(transactions: {result: "success"}).group(:id).to_sql

      puts Merchant.select("merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue").joins(invoices: [:invoice_items, :transactions]).where(transactions: {result: "success"}).group(:id).to_sql

      puts Merchant.select("merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue").joins(invoices: [:invoice_items, :transactions]).where(transactions: {result: "success"}).group(:id).order('revenue DESC').to_sql

    rails db
      SELECT merchants.* FROM "merchants" INNER JOIN "invoices" ON "invoices"."merchant_id" = "merchants"."id" INNER JOIN "invoice_items" ON "invoice_items"."invoice_id" = "invoices"."id" INNER JOIN "transactions" ON "transactions"."invoice_id" = "invoices"."id" WHERE "transactions"."result" = 'success' GROUP BY "merchants"."id";

      SELECT merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue FROM "merchants" INNER JOIN "invoices" ON "invoices"."merchant_id" = "merchants"."id" INNER JOIN "invoice_items" ON "invoice_items"."invoice_id" = "invoices"."id" INNER JOIN "transactions" ON "transactions"."invoice_id" = "invoices"."id" WHERE "transactions"."result" = 'success' GROUP BY "merchants"."id";

      SELECT merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue FROM "merchants" INNER JOIN "invoices" ON "invoices"."merchant_id" = "merchants"."id" INNER JOIN "invoice_items" ON "invoice_items"."invoice_id" = "invoices"."id" INNER JOIN "transactions" ON "transactions"."invoice_id" = "invoices"."id" WHERE "transactions"."result" = 'success' GROUP BY "merchants"."id" ORDER BY revenue DESC;

Converting ActiveRecord to Model Method

  Merchant Model

    def self.most_revenue(limit)
      select("merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue")
        .joins(invoices: [:invoice_items, :transactions])
        .where(transactions: {result: "success"})
        .group(:id)
        .order('revenue DESC')
        .limit(limit)
    end

  Transaction Model

    default_scope { order(id: :asc) }
    scope :successful, -> { where(result: "success") }

  Merchant Model

    def self.most_revenue(limit)
      select("merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue")
        .joins(invoices: [:invoice_items, :transactions])
        .merge(Transaction.unscope.successful)
        .group(:id)
        .order('revenue DESC')
        .limit(limit)
    end

Update for typo (unscope to unscoped, singular unscope is allowed, but you pass an argument of what to unscope instead of defaulting to everything above the scope you are actually calling)

Update for second check on Invoice result = "shipped"

  Merchant Model
    def self.most_revenue(quantity)
      select("merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue")
        .joins(invoices: [:invoice_items, :transactions])
        .merge(Transaction.unscoped.successful)
        .merge(Invoice.unscoped.successful)
        .group(:id)
        .order('revenue DESC')
        .limit(quantity)
    end
