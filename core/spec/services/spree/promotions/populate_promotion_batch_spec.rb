require 'spec_helper'

module Spree
  describe Promotions::PopulatePromotionBatch do
    describe "#call" do
      subject(:populate_promotion_batch) { described_class.new(template_promotion_id, batch_id, options).call }

      let(:template_promotion_id) { double }
      let(:batch_id) { double }
      let(:options) { {batch_size: 3} }

      before do
        allow(Spree::Promotions::DuplicatePromotionJob)
          .to receive(:perform_later)
          .with(options)
      end

      it "enqueues DuplicatePromotionJob jobs", sidekiq: :inline do
        expect(Spree::Promotions::DuplicatePromotionJob)
          .to receive(:perform_later)
          .at_least(options[:batch_size]).times
          .with(template_promotion_id: template_promotion_id, batch_id: batch_id, options: {})

        populate_promotion_batch
      end
    end
  end
end