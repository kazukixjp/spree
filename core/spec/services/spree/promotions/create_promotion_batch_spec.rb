require 'spec_helper'

module Spree
  describe Promotions::CreatePromotionBatch do
    describe "#call" do
      subject(:batch) { described_class.call(promotion, size) }

      let(:promotion) { create(:promotion) }
      let(:size) { 50 }

      it "enqueues DuplicatePromotionJob jobs", sidekiq: :inline do
        expect(DuplicatePromotionJob)
          .to receive(:perform_async)
          .at_least(50).times
          .with(promotion.id)

        batch
      end
    end
  end
end

