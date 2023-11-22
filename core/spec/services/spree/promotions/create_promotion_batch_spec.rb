require 'spec_helper'

module Spree
  describe Promotions::CreatePromotionBatch do
    describe "#call" do
      subject(:create_promotion_batch) { described_class.call(promotion, size) }

      let(:promotion) { build(:promotion) }
      let(:promotion_batch) { instance_double(Spree::PromotionBatch, id: 123) }
      let(:size) { 50 }

      before do
        allow(Spree::Promotion)
          .to receive(:find)
          .and_return(promotion)
        allow(Spree::PromotionBatch)
          .to receive(:create!)
          .and_return(promotion_batch)
        allow(Spree::Promotions::DuplicatePromotionJob)
          .to receive(:perform_later)
          .with(promotion.id, promotion_batch.id)
      end

      it "creates a PromotionBatch" do
        expect(Spree::PromotionBatch)
          .to receive(:create!)

          create_promotion_batch
      end

      it "enqueues DuplicatePromotionJob jobs", sidekiq: :inline do
        expect(Spree::Promotions::DuplicatePromotionJob)
          .to receive(:perform_later)
          .at_least(50).times
          .with(promotion.id, promotion_batch.id)

        create_promotion_batch
      end
    end
  end
end

