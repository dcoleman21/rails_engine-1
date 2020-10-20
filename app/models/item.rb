class Item < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true

  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  def self.single_finder(attribute, query)
    if attribute == "created_at" || attribute == "updated_at"
      Item.where("to_char(#{attribute},'yyyy-mon-dd-HH-MI-SS') ILIKE ?", "%#{query}%").first
    elsif attribute == "unit_price"
      Item.where("to_char(#{attribute}, '999999999.99') ILIKE ?", "%#{query}%").first
    else
      Item.where("#{attribute} ILIKE ?", "%#{query}%").first
    end
  end

  def self.multi_finder(attribute, query)
    if attribute == "created_at" || attribute == "updated_at"
      Item.where("to_char(#{attribute},'yyyy-mon-dd-HH-MI-SS') ILIKE ?", "%#{query}%")
    elsif attribute == "unit_price"
      Item.where("to_char(#{attribute}, '999999999.99') ILIKE ?", "%#{query}%")
    else
      Item.where("#{attribute} ILIKE ?", "%#{query}%")
    end
  end
end
