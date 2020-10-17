class Transaction < ApplicationRecord
  validates :card, presence: true
  validates :card_exp, presence: true
  validates :result, presence: true

  belongs_to :invoice
end
