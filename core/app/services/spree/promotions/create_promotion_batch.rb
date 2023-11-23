module Spree
  module Promotions
    class CreatePromotionBatch
      def self.call(promotion, size)
        promotion_batch = Spree::PromotionBatch.create!(template_promotion_id: promotion.id)

        size.times do
          DuplicatePromotionJob.perform_later(promotion.id, promotion_batch.id)
        end
      end
    end
  end
end
