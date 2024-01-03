module Spree
  module Api
    module V2
      module Platform
        class PromotionBatchesController < ResourceController
          def csv_export
            send_data Spree::PromotionBatches::PromotionCodesExporter.new(params).call,
                      filename: "promo_codes_from_batch_id_#{params[:id]}.csv",
                      disposition: :attachment,
                      type: 'text/csv'
          end

          def csv_import
          end

          private

          def model_class
            Spree::PromotionBatch
          end

          def scope_includes
            [:promotion]
          end

          def spree_permitted_attributes
          end
        end
      end
    end
  end
end
