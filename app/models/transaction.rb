class Transaction < ApplicationRecord
  validates :card, presence: true
  validates :result, presence: true

  belongs_to :invoice
  
  default_scope { order(id: :asc) }
  scope :successful, -> { where(result: "success") }
end
