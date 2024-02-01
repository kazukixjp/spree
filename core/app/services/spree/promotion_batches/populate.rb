module Spree
  module PromotionBatches
    class Populate
      def call(promotion_batch:)
        ::Spree::PromotionBatch.transaction do
          promotion_batch.start
          codes = promotion_batch.codes
          template_promotion = promotion_batch.template_promotion

          codes.each do |code|
            duplicator = ::Spree::PromotionHandler::PromotionBatchDuplicator.new(template_promotion, promotion_batch.id, code: code)
            duplicator.duplicate
          end

          promotion_batch.complete
        end
      rescue => e
        promotion_batch.error
        raise e
      end
    end
  end
end
