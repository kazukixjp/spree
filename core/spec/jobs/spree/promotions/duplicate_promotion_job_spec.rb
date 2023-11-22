require 'spec_helper'

module Spree
  describe Promotions::DuplicatePromotionJob do
    describe "#perform" do
      subject(:execute_job) { described_class.new.perform(promotion.id, batch.id) }

      let(:promotion) { build(:promotion) }
      let(:batch) { instance_double(Spree::PromotionBatch, id: 123) }
      let(:duplicator) { instance_double(Spree::PromotionHandler::PromotionDuplicator) }

      before do
        allow(Spree::Promotion)
          .to receive(:find)
          .and_return(promotion)
      end

      it "sends #duplicate to the duplicator service" do
        expect(Spree::PromotionHandler::PromotionBatchDuplicator)
          .to receive(:new)
          .with(promotion, batch.id)
          .and_return(duplicator)
        expect(duplicator)
          .to receive(:duplicate)

          execute_job
      end
    end
  end
end
