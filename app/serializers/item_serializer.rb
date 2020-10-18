class ItemSerializer
  include FastJsonapi::ObjectSerializer
  belongs_to :merchant
  attributes :name, :description, :unit_price, :created_at, :updated_at, :merchant_id
end
