module Spree
  module PromotionHandler
    class PromotionBatchUpdateHandler < Spree::PromotionDuplicatorCore
      def initialize(template_promotion, promotion_batch_id, descendant_promotion)
        @template_promotion = template_promotion
        @promotion_batch_id = promotion_batch_id
        @descendant_promotion = descendant_promotion
      end

      def duplicate
        @new_promotion = @template_promotion.dup
        @new_promotion.usage_limit = 1
        @new_promotion.promotion_batch_id = @promotion_batch_id
        @new_promotion.path = "#{@template_promotion.path}_#{@random_string}"
        code_assignment
        @new_promotion.stores = @template_promotion.stores

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
