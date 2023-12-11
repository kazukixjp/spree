require 'spec_helper'

module Spree
  describe Promotions::PopulatePromotionBatch do
    describe "#call" do
      subject(:populate_promotion_batch) { described_class.new(config).call }

      let(:config) { {batch_size: 3} }

      before do
        allow(Spree::Promotions::DuplicatePromotionJob)
          .to receive(:perform_later)
          .with(config)
      end

      it "enqueues DuplicatePromotionJob jobs", sidekiq: :inline do
        expect(Spree::Promotions::DuplicatePromotionJob)
          .to receive(:perform_later)
          .at_least(config[:batch_size]).times
          .with(config)

        populate_promotion_batch
      end
    end
  end
end