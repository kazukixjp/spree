module Spree
  module Promotions
    class DuplicatePromotionJob < Spree::BaseJob
      def perform(template_promotion_id:, batch_id:, options: {}, code: nil)
        promotion = find_instance(template_promotion_id, model: Spree::Promotion)
        code = code || applicable_code(batch_id, options)

        Spree::PromotionHandler::PromotionBatchDuplicator.new(promotion, batch_id, code: code).duplicate
      rescue CodeGenerator::MutuallyExclusiveInputsError, CodeGenerator::RetriesDepleted, ActiveRecord::RecordNotUnique => e
        Rails.logger.error(e.message)
      end

      private

      def find_instance(id, model:)
        model.find(id)
      end

      def applicable_code(id, options)
        promotion_batch = find_instance(id, model: Spree::PromotionBatch)
        codes = codes(promotion_batch)
        code_generator = code_generator(options)

        loop do
          candidate = generate_code(code_generator)
          break candidate if candidate_valid?(candidate, codes)
        end
      end

      def codes(promotion_batch)
        promotion_batch.promotions.pluck :code
      end

      def code_generator(options)
        CodeGenerator.new(content: options[:content], affix: options[:affix], deny_list: options[:deny_list])
      end

      def generate_code(generator)
        generator.build
      end

      def candidate_valid?(candidate, codes)
        codes.exclude?(candidate)
      end
    end
  end
end
