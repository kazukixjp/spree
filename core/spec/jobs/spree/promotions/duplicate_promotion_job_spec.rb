require 'spec_helper'

module Spree
  describe Promotions::DuplicatePromotionJob do
    describe "#perform" do
      let(:promotion) { build(:promotion, code: existing_code) }
      let(:promotion_batch) { build(:promotion_batch) }
      let(:duplicator) { instance_double(Spree::PromotionHandler::PromotionDuplicator) }
      let(:code_generator) { instance_double(Promotions::CodeGenerator) }
      let(:existing_code) { "existing_code" }
      let(:new_code) { 'new_code' }

      before do
        allow(Spree::Promotion)
          .to receive(:find)
          .and_return(promotion)
        allow(Spree::PromotionBatch)
          .to receive(:find)
          .and_return(promotion_batch)
      end

      context 'when code is NOT provided' do
        let(:options) { {key: 'value'} }

        subject(:execute_job) do
          described_class.new.perform(template_promotion_id: promotion.id, batch_id: promotion_batch.id, options: options)
        end

        before do
          allow(promotion_batch)
            .to receive(:promotions)
            .and_return([promotion])
          allow(Promotions::CodeGenerator)
            .to receive(:new)
            .with(options)
            .and_return(code_generator)
          allow(code_generator)
            .to receive(:build)
            .and_return(existing_code, new_code)
          allow(Spree::PromotionHandler::PromotionBatchDuplicator)
            .to receive(:new)
            .with(promotion, promotion_batch.id, code: new_code)
            .and_return(duplicator)
          allow(duplicator)
            .to receive(:duplicate)
        end

        it "sends #duplicate to the duplicator service" do
          expect(Spree::PromotionHandler::PromotionBatchDuplicator)
            .to receive(:new)
            .with(promotion, promotion_batch.id, code: new_code)
            .and_return(duplicator)
          expect(duplicator)
            .to receive(:duplicate)

          execute_job
        end
      end

      context 'when code IS provided' do
        subject(:execute_job) do
          described_class.new.perform(template_promotion_id: promotion.id, batch_id: promotion_batch.id, code: specified_code)
        end

        let(:specified_code) { 'specified_code' }

        it "sends #duplicate to the duplicator service" do
          expect(Spree::PromotionHandler::PromotionBatchDuplicator)
            .to receive(:new)
            .with(promotion, promotion_batch.id, code: specified_code)
            .and_return(duplicator)
          expect(duplicator)
            .to receive(:duplicate)

          execute_job
        end
      end
    end
  end
end
