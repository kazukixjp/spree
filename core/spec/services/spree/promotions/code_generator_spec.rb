require 'spec_helper'

module Spree
  describe Promotions::CodeGenerator do
    describe "#build" do
      subject(:generate_code) { described_class.new(config).build }

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
          expect(generate_code).to eq config[:content].concat(random_code)
        end
      end

      context "suffix" do
        let(:config) do
          {
            affix: :suffix,
            content: "black_week"
          }
        end

        it "creates a code with a given suffix" do
          expect(generate_code).to eq random_code.concat(config[:content])
        end
      end

      context "deny-list" do
        let(:forbidden_phrases) { %w(forbidden phrase) }
        let(:config) do
          {
            deny_list: forbidden_phrases
          }
        end

        before do
          allow(SecureRandom)
            .to receive(:hex).with(4)
            .and_return("foo_#{forbidden_phrases.first}_bar", "foo_#{forbidden_phrases.last}_bar", random_code)
        end

        it "discards code containing forbidden phrases" do
          expect(generate_code).to eq random_code
        end
      end

      context "default" do
        subject(:generate_code) { described_class.new.build }

        it "creates a code" do
          expect(generate_code).to eq random_code
        end
      end
    end
  end
end
