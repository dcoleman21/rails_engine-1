FactoryBot.define do
  FactoryBot.define do
    factory :transaction do
      card { Faker::Finance.credit_card(:visa) }
      result { "failed" }
      invoice_id { Faker::Number.within(range: 1..10000) }
      invoice
    end
  end
end
