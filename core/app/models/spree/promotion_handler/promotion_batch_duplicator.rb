module Spree
  module PromotionHandler
    class PromotionBatchDuplicator < Spree::PromotionDuplicatorCore
      def initialize(promotion, promotion_batch_id, random_string: nil, code: nil)
        @promotion = promotion
        @promotion_batch_id = promotion_batch_id
        @random_string = random_string || generate_random_string(4)
        @code = code
      end

      def duplicate
        @new_promotion = @promotion.dup
        @new_promotion.promotion_batch_id = @promotion_batch_id
        @new_promotion.path = "#{@promotion.path}_#{@random_string}"
        code_assignment
        @new_promotion.stores = @promotion.stores

        ActiveRecord::Base.transaction do
          @new_promotion.save
          copy_rules
          copy_actions
        end

        @new_promotion
      end

      private

      def code_assignment
        return @new_promotion.generate_code=(true) unless @code

        @new_promotion.code = @code
      end
    end
  end
end
