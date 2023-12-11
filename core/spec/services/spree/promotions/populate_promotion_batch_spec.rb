require 'spec_helper'

module Spree
  describe Promotions::PopulatePromotionBatch do
    describe "#call" do
      subject(:populate_promotion_batch) { described_class.new(config).call }

      let(:config) do
        {
          template_promotion_id: 1,
          id: 2,
          batch_size: 3,
          affix: :prefix,
          content: 'blackweek',
          deny_list: %w(forbidden words)
        }
      end
      let(:code_generator) { instance_double(Promotions::CodeGenerator) }
      let(:code) { 'code' }

      before do
        allow(Promotions::CodeGenerator)
          .to receive(:new)
          .with(config)
          .and_return(code_generator)
        allow(code_generator)
          .to receive(:build)
          .and_return(code)
        allow(Spree::Promotions::DuplicatePromotionJob)
          .to receive(:perform_later)
          .with(config[:template_promotion_id], config[:id], code: code)
      end

      it "enqueues DuplicatePromotionJob jobs", sidekiq: :inline do
        expect(Spree::Promotions::DuplicatePromotionJob)
          .to receive(:perform_later)
          .at_least(config[:batch_size]).times
          .with(config[:template_promotion_id], config[:id], code: code)

        populate_promotion_batch
      end
    end
  end
end