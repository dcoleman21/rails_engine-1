class Transaction < ApplicationRecord
  validates :card, presence: true
  validates :result, presence: true

  belongs_to :invoice
end
