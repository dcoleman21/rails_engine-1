FactoryBot.define do
  FactoryBot.define do
    factory :invoice_item do
      quantity { Faker::Number.within(range: 1..25) }
      unit_price { Faker::Commerce.price(range: 0..10000.0) }
      item_id { Faker::Number.within(range: 1..10000) }
      invoice_id { Faker::Number.within(range: 1..10000) }
      item
      invoice
    end
  end
end
