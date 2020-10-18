class UpdateCardFromTransactions < ActiveRecord::Migration[5.2]
  def change
    change_column :transactions, :card, :integer, limit: 8
  end
end
