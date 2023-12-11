require 'spec_helper'

module Spree
  describe PromotionBatches::PromoCodesImporter do
    subject(:import_promo_codes) do
      described_class.new(content: content, promotion_batch_id: promotion_batch.id).call
    end

    let(:promotion_batch) { build(:promotion_batch) }
    let(:code1) { 'cf14cec8' }
    let(:code2) { '4b2ff1a7' }
    let(:template_promotion_id) { double }
    let(:id) { double }
    let(:content) do
      <<~CSV
        #{code1}
        #{code2}
      CSV
    end
    let(:config) { {template_promotion_id: template_promotion_id, id: id} }

    before do
      allow(Spree::PromotionBatch)
        .to receive(:find)
        .and_return(promotion_batch)
      allow(promotion_batch)
        .to receive(:template_promotion_id)
        .and_return(template_promotion_id)
      allow(promotion_batch)
        .to receive(:id)
        .and_return(id)
    end

    it "enqueues DuplicatePromotionJob jobs", sidekiq: :inline do
      expect(Spree::Promotions::DuplicatePromotionJob)
        .to receive(:perform_later)
        .with(config, code: code1)
      expect(Spree::Promotions::DuplicatePromotionJob)
        .to receive(:perform_later)
        .with(config, code: code2)

      import_promo_codes
    end
  end
end
