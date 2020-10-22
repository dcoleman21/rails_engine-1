class Customer < ApplicationRecord
  validates :first_name, presence: true
  validates :last_name, presence: true

  has_many :invoices

  def self.best_repeater(quantity)
    select("customers.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue")
      .joins(invoices: [:invoice_items, :transactions])
      .merge(Transaction.unscoped.successful)
      .merge(Invoice.unscoped.successful)
      .group(:id)
      .order('revenue DESC')
      .having("count(*) > 1")
      .limit(quantity)
  end
end
