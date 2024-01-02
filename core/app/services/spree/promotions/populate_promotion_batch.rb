module Spree
  module Promotions
    class PopulatePromotionBatch
      def initialize(template_promotion_id, batch_id, options = {})
        @template_promotion_id = template_promotion_id
        @batch_id = batch_id
        @options = options
      end

      def call
        size.times do
          DuplicatePromotionJob.perform_later(template_promotion_id: template_promotion_id, batch_id: batch_id, options: options.except(:batch_size))
        end
      end

      private

      attr_accessor :options
      attr_reader :template_promotion_id, :batch_id

      def size
        options[:batch_size]
      end
    end
  end
end
