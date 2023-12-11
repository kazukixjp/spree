module Spree
  module Promotions
    class PopulatePromotionBatch
      def initialize(config)
        @config = config
      end

      def call
        size.times do
          code = CodeGenerator.new(config).build
          DuplicatePromotionJob.perform_later(config[:template_promotion_id], config[:id], code: code)
        end
      end

      private

      attr_accessor :config

      def size
        config.delete(:batch_size)
      end
    end
  end
end
