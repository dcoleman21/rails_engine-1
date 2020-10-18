class MerchantSerializer
  def self.format_merchants(merchants)
    merchants.map do |merchant|
      {
        :data=> [
          {
            id: merchant.id,
            type: "Merchant",
            attributes: {
              name: merchant.name,
              created_at: merchant.created_at,
              updated_at: merchant.updated_at
            }
          },
          {
            id: merchant.id,
            type: "Merchant",
            attributes:  {
              name: merchant.name,
              created_at: merchant.created_at,
              updated_at: merchant.updated_at
            }
          },
          {
            id: merchant.id,
            type: "Merchant",
            attributes:  {
              name: merchant.name,
              created_at: merchant.created_at,
              updated_at: merchant.updated_at
            }
          }
        ]
      }
    end
  end
end
