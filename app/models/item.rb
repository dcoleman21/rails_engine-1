class Item < ApplicationRecord
  validates :name, presence: true, allow_nil: false
  validates :description, presence: true, allow_nil: false
  validates :unit_price, presence: true, allow_nil: false

  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  def self.single_finder(attribute, query)
    if attribute == "created_at" || attribute == "updated_at"
      date_helper(attribute, query).first
    elsif attribute == "unit_price"
      price_helper(attribute, query).first
    else
      search_helper(attribute, query).first
    end
  end

  def self.multi_finder(attribute, query)
    if attribute == "created_at" || attribute == "updated_at"
      date_helper(attribute, query)
    elsif attribute == "unit_price"
      price_helper(attribute, query)
    else
      search_helper(attribute, query)
    end
  end

  def self.date_helper(attribute, query)
    where("to_char(#{attribute},'yyyy-mon-dd-HH-MI-SS') ILIKE ?", "%#{query}%")
  end

  def self.price_helper(attribute, query)
    where("to_char(#{attribute}, '999999999.99') ILIKE ?", "%#{query}%")
  end

  def self.search_helper(attribute, query)
    where("#{attribute} ILIKE ?", "%#{query}%")
  end

  def self.reset_primary_keys
    ActiveRecord::Base.connection.reset_pk_sequence!('items')
  end
end
