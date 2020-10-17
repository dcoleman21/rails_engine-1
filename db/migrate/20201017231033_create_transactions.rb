class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.integer :card
      t.string :card_exp
      t.string :result
      t.references :invoice, foreign_key: true

      t.timestamps
    end
  end
end
