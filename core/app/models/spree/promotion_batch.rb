module Spree
  class PromotionBatch < Spree::Base
    has_many :promotions
  end
end
