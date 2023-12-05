module Spree
  module Promotions
    class UpdateDescendantJob < Spree::BaseJob
      def perform(promotion_id, template_promotion_id)
        promotion = find_promotion(promotion_id)
        template_promotion = find_promotion(template_promotion_id)
      end

      private

      def find_promotion(id)
        Spree::Promotion.find(id)
      end

      def recreate_promotion
        Spree::PromotionHandler::PromotionBatchDuplicator.new(promotion, promotion_batch_id, code: code).duplicate
      end
    end
  end
end
