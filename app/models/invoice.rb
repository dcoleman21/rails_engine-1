class Invoice < ApplicationRecord
  validates :status, presence: true

  belongs_to :customer
  belongs_to :merchant
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items

  default_scope { order(id: :asc) }
  scope :successful, -> { where(status: "shipped") }

  def self.most_expensive(limit = 5, sorting = "DESC")
    select("invoices.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue")
      .joins(:invoice_items, :transactions)
      .merge(Transaction.unscoped.successful)
      .group(:id)
      .order("revenue #{sorting}")
      .limit(limit)
  end
end
