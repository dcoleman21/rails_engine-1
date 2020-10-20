class RevenueFacade
  def self.total_revenue(start_date, end_date)
    total = Invoice.joins(:invoice_items, :transactions)
                   .merge(Transaction.unscoped.successful)
                   .merge(Invoice.unscoped.successful)
                   .where(created_at: Date.parse(start_date.to_s).beginning_of_day..Date.parse(end_date.to_s).end_of_day)
                   .sum('invoice_items.quantity * invoice_items.unit_price')
    Revenue.new(total)
  end
end
