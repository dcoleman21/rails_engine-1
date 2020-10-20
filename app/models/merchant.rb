class Merchant < ApplicationRecord
  validates :name, presence: true

  has_many :items
  has_many :invoices

  def self.single_finder(attribute, query)
    if attribute == "created_at" || attribute == "updated_at"
      Merchant.where("to_char(#{attribute},'yyyy-mon-dd-HH-MI-SS') ILIKE ?", "%#{query}%").first
    else
      Merchant.where("#{attribute} ILIKE ?", "%#{query}%").first
    end
  end

  def self.multi_finder(attribute, query)
    if attribute == "created_at" || attribute == "updated_at"
      Merchant.where("to_char(#{attribute},'yyyy-mon-dd-HH-MI-SS') ILIKE ?", "%#{query}%")
    else
      Merchant.where("#{attribute} ILIKE ?", "%#{query}%")
    end
  end

  def self.most_revenue(quantity)
    select("merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue")
      .joins(invoices: [:invoice_items, :transactions])
      .merge(Transaction.unscoped.successful)
      .merge(Invoice.unscoped.successful)
      .group(:id)
      .order('revenue DESC')
      .limit(quantity)
  end

  def self.most_items(quantity)
    select("merchants.*, SUM(invoice_items.quantity) AS quantity_of_items")
      .joins(invoices: [:invoice_items, :transactions])
      .merge(Transaction.unscoped.successful)
      .merge(Invoice.unscoped.successful)
      .group(:id).order('quantity_of_items DESC')
      .limit(quantity)
  end

  def revenue
    merchant_revenue = Invoice.joins(:invoice_items, :transactions)
           .merge(Transaction.unscoped.successful)
           .merge(Invoice.unscoped.successful)
           .where(merchant_id: self.id)
           .sum('unit_price * quantity')
    Revenue.new(merchant_revenue)
  end
end
