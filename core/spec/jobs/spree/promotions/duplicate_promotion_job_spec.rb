require 'spec_helper'

module Spree
  describe Promotions::DuplicatePromotionJob do
    describe "#perform" do
      let(:promotion) { build(:promotion, code: existing_code) }
      let(:promotion_batch) { build(:promotion_batch, template_promotion: promotion) }
      let(:duplicator) { instance_double(Spree::PromotionHandler::PromotionDuplicator) }
      let(:code_generator) { instance_double(Promotions::CodeGenerator) }
      let(:existing_code) { "existing_code" }
      let(:new_code) { 'new_code' }

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

      before do
        allow(Spree::Promotion)
          .to receive(:find)
          .with(config[:template_promotion_id])
          .and_return(promotion)
        allow(Spree::PromotionBatch)
          .to receive(:find)
          .with(config[:id])
          .and_return(promotion_batch)
        allow(promotion_batch)
          .to receive(:promotions)
          .and_return([promotion])
        allow(Promotions::CodeGenerator)
          .to receive(:new)
          .with(config)
          .and_return(code_generator)
        allow(code_generator)
          .to receive(:build)
          .and_return(existing_code, new_code)
        allow(Spree::PromotionHandler::PromotionBatchDuplicator)
          .to receive(:new)
          .with(promotion, config[:id], code: new_code)
          .and_return(duplicator)
        allow(duplicator)
          .to receive(:duplicate)
      end

      subject(:execute_job) { described_class.new.perform(config) }

      it "sends #duplicate to the duplicator service" do
        expect(Spree::PromotionHandler::PromotionBatchDuplicator)
          .to receive(:new)
          .with(promotion, config[:id], code: new_code)
          .and_return(duplicator)
        expect(duplicator)
          .to receive(:duplicate)

        execute_job
      end
    end
  end
end
