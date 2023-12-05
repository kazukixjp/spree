require 'spec_helper'

describe Spree::PromotionHandler::UpdateDescendantsService do
  subject { described_class.new(promotion).call }

  let(:promotion) { build(:promotion) }
  let(:batches) { [build(:promotion_batch)] }

  context 'when the promotion is a template for a batch' do
    before do
      allow(Spree::PromotionBatch)
        .to receive(where)
        .with(template_promotion_id: promotion.id )
        .and_return(batches)
    end

    it 'enqueues a job' do
      expect(Job).to receive(:perform_later)

      subject
    end
  end

  context 'when the promotion is NOT a template for a batch' do
    before do
      allow(Spree::PromotionBatch)
        .to receive(where)
        .with(template_promotion_id: promotion.id )
        .and_return([])
    end

    it 'does not enqueue a job' do
      expect(Job).not_to receive(:perform_later)

      subject
    end
  end
end
