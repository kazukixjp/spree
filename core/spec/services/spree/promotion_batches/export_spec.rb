require 'spec_helper'

module Spree
  describe PromotionBatches::Export do
    let(:exporter) { described_class.new }

    subject { exporter.call(promotion_batch: promotion_batch )}

    let(:promotion_batch) { create(:promotion_batch, promotions: [promotion1, promotion2]) }
    let(:promotion1) { create(:promotion, :with_unique_code) }
    let(:promotion2) { create(:promotion, :with_unique_code) }

    let(:expected_codes_csv) do
      <<~CSV
        #{promotion.code}
        #{promotion2.code}
      CSV
    end

    it 'generates correct csv file' do
      expect(input).to eq expected_codes_csv
    end
  end
end
