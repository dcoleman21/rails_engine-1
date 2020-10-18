FactoryBot.define do
  FactoryBot.define do
    factory :item do
      name { Faker::Games::Zelda.item }
      description { Faker::Lorem.paragraph(sentence_count: 20, supplemental: true, random_sentences_to_add: 4) }
      merchant_id { Faker::Number.within(range: 1..10000) }
      unit_price { Faker::Number.decimal(l_digits: (Faker::Number.within(range: 1..10)), r_digits: 2 ) }
      merchant
    end
  end
end
