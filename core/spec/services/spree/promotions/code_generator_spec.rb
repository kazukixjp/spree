require 'spec_helper'

module Spree
  describe Promotions::CodeGenerator do
    describe "#build" do
      subject(:generated_code) { described_class.new(config).build }

      let(:random_code) { 'secure_random_code' }

      before do
        allow(SecureRandom).to receive(:hex).with(4).and_return(random_code)
      end

      context "prefix" do
        let(:config) do
          {
            affix: :prefix,
            content: "black_week"
          }
        end

        it "creates a code with a given prefix" do
          expect(generated_code).to eq config[:content].concat(random_code)
        end
      end
    end
  end
end
