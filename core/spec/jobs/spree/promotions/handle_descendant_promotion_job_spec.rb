require 'spec_helper'

module Spree
  describe Promotions::HandleDescendantPromotionJob do
    describe "#perform" do
      let(:template_promotion) { build(:promotion) }
      let(:promotion) { build(:promotion) }
      let(:batch) { instance_double(Spree::PromotionBatch, id: 123) }
      let(:duplicator) { instance_double(Spree::PromotionHandler::XXXX) }

      before do
        allow(Spree::Promotion)
          .to receive(:find)
          .and_return(template_promotion, promotion)
      end

      subject(:execute_job) { described_class.new.perform(template_promotion.id, batch.id, promotion.id) }

      it "sends #duplicate to the duplicator service" do
        expect(Spree::PromotionHandler::XXXX)
          .to receive(:new)
          .with(template_promotion, batch.id, promotion)
          .and_return(duplicator)
        expect(duplicator)
          .to receive(:duplicate)

        execute_job
      end
    end
  end
end
