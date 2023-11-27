module Spree
  module PromotionBatches
    class PromoCodesImporter
      def initialize(content:, promotion_batch_id:)
        @content = content
        @promotion_batch = find_promotion_batch(promotion_batch_id)
      end

      def call
        parsed_rows.each do |parsed_row|
          Spree::Promotions::DuplicatePromotionJob
            .perform_later(@promotion_batch.template_promotion_id, @promotion_batch.id, code: parsed_row)
        end
      end

      private

      def find_promotion_batch(id)
        Spree::PromotionBatch.find(id)
      end

      def parsed_rows
        CSV.new(rows, headers: false).read.map(&:first)
      end

      def rows
        @content.lines.join
      end
    end  
  end
end
