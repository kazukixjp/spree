require 'spec_helper'

describe PromotionBatches::PromoCodesExporter do
  subject(:input) do
    described_class.new(params).call
  end
end
