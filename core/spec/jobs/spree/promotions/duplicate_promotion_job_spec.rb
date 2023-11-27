require 'spec_helper'

module Spree
  describe Promotions::DuplicatePromotionJob do
    describe "#perform" do
      let(:promotion) { build(:promotion) }
      let(:batch) { instance_double(Spree::PromotionBatch, id: 123) }
      let(:duplicator) { instance_double(Spree::PromotionHandler::PromotionDuplicator) }

      before do
        allow(Spree::Promotion)
          .to receive(:find)
          .and_return(promotion)
      end

      context "when code is provided" do
        subject(:execute_job) { described_class.new.perform(promotion.id, batch.id, code: code) }
        let(:code) { 'ed4517b3' }

        it "sends #duplicate to the duplicator service" do
          expect(Spree::PromotionHandler::PromotionBatchDuplicator)
            .to receive(:new)
            .with(promotion, batch.id, code: code)
            .and_return(duplicator)
          expect(duplicator)
            .to receive(:duplicate)

          execute_job
        end
      end

      context "when code is  NOT provided" do
        subject(:execute_job) { described_class.new.perform(promotion.id, batch.id) }

        it "sends #duplicate to the duplicator service" do
          expect(Spree::PromotionHandler::PromotionBatchDuplicator)
            .to receive(:new)
            .with(promotion, batch.id, code: nil)
            .and_return(duplicator)
          expect(duplicator)
            .to receive(:duplicate)

          execute_job
        end
      end
    end
  end
end
