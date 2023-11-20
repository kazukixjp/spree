require 'spec_helper'

module Spree
  describe Promotions::DuplicatePromotionJob do
    describe "#perform" do
      subject(:execute_job) { described_class.new.perform(promotion.id) }

      let(:promotion) { build(:promotion) }

      let(:double) { instance_double(Spree::PromotionHandler::PromotionDuplicator) }

      before do
        allow(Spree::Promotion)
          .to receive(:find)
          .and_return(promotion)
      end

      it "sends #duplicate to the duplicator service" do
        expect(Spree::PromotionHandler::PromotionDuplicator)
          .to receive(:new)
          .with(promotion)
          .and_return(double)
        expect(double)
          .to receive(:duplicate)

          execute_job
      end
    end
  end
end
