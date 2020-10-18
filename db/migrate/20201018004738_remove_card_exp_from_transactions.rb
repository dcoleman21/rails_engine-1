class RemoveCardExpFromTransactions < ActiveRecord::Migration[5.2]
  def change
    remove_column :transactions, :card_exp, :string
  end
end
