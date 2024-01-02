module Spree
  module PromotionBatches
    class PromotionCodesImporter
      Error = Class.new(StandardError)

      def initialize(content:, promotion_batch_id:)
        @content = content
        @promotion_batch = find_promotion_batch(promotion_batch_id)
      end

      def call
        validate_file!
        validate_promotion_batch!

        parsed_rows.each do |parsed_row|
          Spree::Promotions::DuplicatePromotionJob
            .perform_later(template_promotion_id: @promotion_batch.template_promotion_id, batch_id: @promotion_batch.id, code: parsed_row)
        end
      end

      private

      def find_promotion_batch(id)
        Spree::PromotionBatch.find(id)
      end

      def validate_file!
        raise Error, Spree.t('invalid_file') if file_validation_condition
      end

      def file_validation_condition
        parsed_rows.blank?
      end

      def validate_promotion_batch!
        raise Error, Spree.t('no_template_promotion') unless batch_validation_condition
      end

      def batch_validation_condition
        @promotion_batch.template_promotion_id
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
