module Spree
  module PromotionBatches
    class PromoCodesImporter
      Error = Class.new(StandardError)

      def initialize(content:, promotion_batch_id:)
        @content = content
        @promotion_batch = find_promotion_batch(promotion_batch_id)
      end

      def call
        validate_file!

        config = { template_promotion_id: @promotion_batch.template_promotion_id, id: @promotion_batch.id }
        parsed_rows.each do |parsed_row|
          Spree::Promotions::DuplicatePromotionJob
            .perform_later(config, code: parsed_row)
        end
      end

      private

      def find_promotion_batch(id)
        Spree::PromotionBatch.find(id)
      end

      def validate_file!
        raise Error, "No file / Empty file" if validation_condition
      end

      def validation_condition
        parsed_rows.blank?
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
