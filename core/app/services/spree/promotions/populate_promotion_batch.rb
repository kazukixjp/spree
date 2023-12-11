module Spree
  module Promotions
    class PopulatePromotionBatch
      def initialize(config)
        @config = config
      end

      def call
        size.times do
          DuplicatePromotionJob.perform_later(config)
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
