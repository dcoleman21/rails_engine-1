FactoryBot.define do
  FactoryBot.define do
    factory :invoice do
      status { "shipped" }
      merchant_id { Faker::Number.within(range: 1..10000) }
      customer_id { Faker::Number.within(range: 1..10000) }
      merchant
      customer
    end
  end
end
