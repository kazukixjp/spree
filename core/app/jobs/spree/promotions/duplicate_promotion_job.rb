module Spree
  module Promotions
    class DuplicatePromotionJob < Spree::BaseJob
      def perform(config, code: nil)
        promotion = find_instance(config[:template_promotion_id], model: Spree::Promotion)
        code = code || applicable_code(config)

        Spree::PromotionHandler::PromotionBatchDuplicator.new(promotion, config[:id], code: code).duplicate
      end

      private

      def find_instance(id, model:)
        model.find(id)
      end

      def applicable_code(config)
        promotion_batch = find_instance(config[:id], model: Spree::PromotionBatch)
        codes = codes(promotion_batch)
        code_generator = code_generator(config)

        loop do
          candidate = generate_code(code_generator)
          break candidate if candidate_valid?(candidate, codes)
        end
      end

      def codes(promotion_batch)
        promotion_batch.promotions.pluck :code
      end

      def code_generator(config)
        CodeGenerator.new(config)
      end

      def generate_code(generator)
        generator.build
      end

      def candidate_valid?(candidate, codes)
        return true unless codes.include?(candidate)

        false
      end
    end
  end
end
