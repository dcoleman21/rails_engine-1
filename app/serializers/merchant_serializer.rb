class MerchantSerializer
  def self.format_merchants(merchants)
      {
        :data=>
          merchants.map do |merchant|
          {
            id: merchant.id,
            type: "merchant",
            attributes: {
              name: merchant.name,
              created_at: merchant.created_at,
              updated_at: merchant.updated_at
            }
          }
        end
      }
  end
end
