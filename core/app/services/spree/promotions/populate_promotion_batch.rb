module Spree
  module Promotions
    class PopulatePromotionBatch
      def self.call(config)
        size(config).times do
          code = CodeGenerator.new(config).build
          DuplicatePromotionJob.perform_later(config[:template_promotion_id], config[:id], code: code)
        end
      end

      private

      def self.size(config)
        config.delete(:batch_size)
      end
    end
  end
end
