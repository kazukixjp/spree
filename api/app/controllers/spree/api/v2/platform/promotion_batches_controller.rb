module Spree
  module Api
    module V2
      module Platform
        class PromotionBatchesController < ResourceController
          def csv_export
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
