module Spree
  class PromotionBatch < Spree::Base
    has_many :promotions
    belongs_to :template_promotion, class_name: "Promotion"

    def template_promotion_name_id
      base = template_promotion.name
      addon = template_promotion_id.to_s
      base.concat(' # ', addon)
    end

    def model_name_id
      base = self.class.name.demodulize
      addon = self.id.to_s
      base.concat(' # ', addon)
    end
  end
end
