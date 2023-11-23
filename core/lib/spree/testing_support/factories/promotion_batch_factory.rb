FactoryBot.define do
  factory :promotion_batch, class: Spree::PromotionBatch do
    status { 'processing' }
  end
end
