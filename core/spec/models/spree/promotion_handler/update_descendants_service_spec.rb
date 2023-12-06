require 'spec_helper'

describe Spree::PromotionHandler::UpdateDescendantsService do
  subject { described_class.new(template_promotion).call }

  let(:template_promotion) { build(:promotion) }
  let(:descendant_promotion) { build(:promotion) }
  let(:batch) { build(:promotion_batch) }
  let(:batches) { [batch] }
  let(:promotions) { [descendant_promotion] }

  context 'when the promotion is a template for a batch' do
    before do
      allow(Spree::PromotionBatch)
        .to receive(:where)
        .with(template_promotion_id: template_promotion.id )
        .and_return(batches)
      allow(batch)
        .to receive(:promotions)
        .and_return(promotions)
    end

    it 'enqueues a job' do
      expect(Spree::Promotions::HandleDescendantPromotionJob)
        .to receive(:perform_later)
        .with(
          template_promotion_id: template_promotion.id,
          descendant_promotion_id: descendant_promotion.id,
          promotion_batch_id: batch.id
        )

      subject
    end
  end

  context 'when the promotion is NOT a template for a batch' do
    before do
      allow(Spree::PromotionBatch)
        .to receive(:where)
        .with(template_promotion_id: template_promotion.id )
        .and_return([])
    end

    it 'does not enqueue a job' do
      expect(Spree::Promotions::HandleDescendantPromotionJob).not_to receive(:perform_later)

      subject
    end
  end
end
