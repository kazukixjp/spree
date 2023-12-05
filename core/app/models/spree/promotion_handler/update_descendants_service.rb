module Spree
  module PromotionHandler
    class UpdateDescendantsService
      def initialize(template_promotion)
        @template_promotion = template_promotion
        @promotions_to_destroy = [] # this needs to get populated
      end

      def call
        return unless promotion_batches?

        ids_and_codes_by_batch.each do |batch|
          batch.each do |batch_id, promotions_data|
            promotions_data.each do |data|
              Job.perform_later(data[:id], batch_id, data[:code])
            end
          end
        end
      end

      private

      def promotion_batches?
        promotion_batches.any?
      end

      def promotion_batches
        @promotion_batches = Spree::PromotionBatch.where(template_promotion_id: @template_promotion.id)
      end

      def ids_and_codes_by_batch
        @promotion_batches.map do |batch|
          {batch.id => unused_codes(batch)}
        end
      end

      def unused_codes(batch)
        unused_promotions(batch).map {|promotion| {id: promotion.id, code: promotion.code}}
      end

      def unused_promotions(batch)
        batch.promotions
          .includes(:promotion_actions)
          .select {|promotion| promotion.credits_count < promotion.usage_limit}
      end
    end
  end
end
