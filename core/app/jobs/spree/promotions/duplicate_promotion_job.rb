module Spree
  module Promotions
    class DuplicatePromotionJob < Spree::BaseJob
      def perform(promotion_id)
        promotion = find_promotion(promotion_id)
        Spree::PromotionHandler::PromotionBatchDuplicator.new(promotion).duplicate
      end

      private

      def find_promotion(id)
        Spree::Promotion.find(id)
      end
    end
  end
end
