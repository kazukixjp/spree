module Spree
  class PromotionBatch < Spree::Base
    has_many :promotions
    belongs_to :template_promotion, class_name: "Promotion"
  end
end
