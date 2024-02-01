module Spree
  module Api
    module V2
      module Platform
        class PromotionBatchesController < ResourceController
          def create
            template_promotion = ::Spree::Promotion.find(params[:template_promotion_id])
            promotion_batch = ::Spree::PromotionBatches::CreateWithRandomCodes.new.call(
              template_promotion: template_promotion,
              amount: params[:amount],
              random_characters: params[:random_characters],
              prefix: params[:prefix],
              suffix: params[:suffix]
            )

            render_serialized_payload { promotion_batch }
          end

          def destroy
            result = destroy_service.call(promotion_batch: resource)

            if result.success?
              head 204
            else
              render_error_payload(result.error)
            end
          end

          def csv_export
            send_data ::Spree::PromotionBatches::Export.new.call(promotion_batch: resource),
                      filename: "promo_codes_from_batch_id_#{params[:id]}.csv",
                      disposition: :attachment,
                      type: 'text/csv'
          end

          def import
            template_promotion = ::Spree::Promotion.find(params[:template_promotion_id])
            promotion_batch = ::Spree::PromotionBatches::CreateWithCodes.new.call(
              template_promotion: template_promotion,
              codes: params[:codes]
            )

            render_serialized_payload { promotion_batch }
          end

          private

          def model_class
            ::Spree::PromotionBatch
          end

          def spree_permitted_attributes
            [:template_promotion_id]
          end

          def destroy_service
            ::Spree::Api::Dependencies.platform_promotion_batch_destroy_service.constantize
          end
        end
      end
    end
  end
end
