module Spree
  module Promotions
    class CreatePromotionBatch
      def self.call(promotion, size)
        size.times do
          DuplicatePromotionJob.perform_async(promotion.id)
        end
      end
    end
  end
end
