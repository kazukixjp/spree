require 'spec_helper'

module Spree
  describe Promotions::CreatePromotionBatch do
    describe "#call" do
      subject(:batch) { described_class.call(promotion, size) }

      let(:promotion) { create(:promotion) }
      let(:size) { 50 }

      it "creates a PromotioBatch" do
        expect{ batch }.to change { Spree::PromotionBatch.count }.by(1)
      end

      it "enqueues DuplicatePromotionJob jobs", sidekiq: :inline do
        expect(Spree::Promotions::DuplicatePromotionJob)
          .to receive(:perform_later)
          .at_least(50).times
          .with(promotion.id)

        batch
      end
    end
  end
end

