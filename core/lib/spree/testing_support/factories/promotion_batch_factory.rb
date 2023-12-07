FactoryBot.define do
  factory :promotion_batch, class: Spree::PromotionBatch do
    status { 'processing' }
    association :template_promotion, factory: :promotion
  end
end
