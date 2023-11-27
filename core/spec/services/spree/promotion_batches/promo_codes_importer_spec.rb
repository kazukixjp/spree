require 'spec_helper'

module Spree
  describe PromotionBatches::PromoCodesImporter do
    subject(:import_promo_codes) do
      described_class.new(params).call
    end

    let(:code1) { 'cf14cec8' }
    let(:code2) { '4b2ff1a7' }
    let(:content) do
      <<~CSV
        #{code1}
        #{code2}
      CSV
    end

    before do
    end

    it "enqueues DuplicatePromotionJob jobs", sidekiq: :inline do
      expect(Spree::Promotions::DuplicatePromotionJob)
        .to receive(:perform_later)
        .with(promotion.id, promotion_batch.id, code1)
      expect(Spree::Promotions::DuplicatePromotionJob)
        .to receive(:perform_later)
        .with(promotion.id, promotion_batch.id, code2)

      import_promo_codes
    end
  end
end
