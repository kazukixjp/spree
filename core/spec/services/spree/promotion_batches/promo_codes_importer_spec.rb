require 'spec_helper'

module Spree
  describe PromotionBatches::PromoCodesImporter do
    subject(:import_promo_codes) do
      described_class.new(content: content, promotion_batch_id: promotion_batch.id).call
    end

    let(:promotion) { build(:promotion) }
    let(:promotion_batch) { build(:promotion_batch, template_promotion_id: promotion.id) }
    let(:code1) { 'cf14cec8' }
    let(:code2) { '4b2ff1a7' }
    let(:content) do
      <<~CSV
        #{code1}
        #{code2}
      CSV
    end

    before do
      allow(Spree::PromotionBatch)
        .to receive(:find)
        .and_return(promotion_batch)
    end

    it "enqueues DuplicatePromotionJob jobs", sidekiq: :inline do
      expect(Spree::Promotions::DuplicatePromotionJob)
        .to receive(:perform_later)
        .with(promotion.id, promotion_batch.id, code: code1)
      expect(Spree::Promotions::DuplicatePromotionJob)
        .to receive(:perform_later)
        .with(promotion.id, promotion_batch.id, code: code2)

      import_promo_codes
    end
  end
end
