class Merchant < ApplicationRecord
  validates :name, presence: true

  has_many :items
  has_many :invoices

  def self.single_finder(attribute, query)
    if attribute == "created_at" || attribute == "updated_at"
      Merchant.where("to_char(#{attribute},'yyyy-mon-dd-HH-MI-SS') ILIKE ?", "%#{query}%").first
    else
      Merchant.where("LOWER(#{attribute}) LIKE ?", "%#{query.downcase}%").first
    end
  end
end
