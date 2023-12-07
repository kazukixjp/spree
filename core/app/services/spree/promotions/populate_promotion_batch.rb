module Spree
  module Promotions
    class PopulatePromotionBatch
      def self.call(promotion_batch, size)
        size.times do
          DuplicatePromotionJob.perform_later(promotion_batch.template_promotion_id, promotion_batch.id)
        end
      end
    end
  end
end
