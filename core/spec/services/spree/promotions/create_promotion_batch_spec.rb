require 'spec_helper'

module Spree
  describe Promotions::CreatePromotionBatch do
    describe "#call" do
      subject(:create_promotion_batch) { described_class.call(promotion_batch, size) }

      let(:promotion_batch) { build(:promotion_batch) }
      let(:template_promotion_id) { double }
      let(:id) { double }
      let(:size) { 50 }

      before do
        allow(promotion_batch)
          .to receive(:template_promotion_id)
          .and_return(template_promotion_id)
        allow(promotion_batch)
          .to receive(:id)
          .and_return(id)
        allow(Spree::Promotions::DuplicatePromotionJob)
          .to receive(:perform_later)
          .with(template_promotion_id, id)
      end

      it "enqueues DuplicatePromotionJob jobs", sidekiq: :inline do
        expect(Spree::Promotions::DuplicatePromotionJob)
          .to receive(:perform_later)
          .at_least(50).times
          .with(template_promotion_id, id)

        create_promotion_batch
      end
    end
  end
end