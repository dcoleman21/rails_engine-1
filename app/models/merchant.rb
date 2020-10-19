class Merchant < ApplicationRecord
  validates :name, presence: true

  has_many :items
  has_many :invoices

  def self.single_finder(attribute, query)
    Merchant.where("LOWER(#{attribute}) LIKE ?", "%#{query.downcase}%").first
  end
end
