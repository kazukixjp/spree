require 'csv'

module Spree
  module PromotionBatches
    class Import
      Error = Class.new(StandardError)

      def call(file:, template_promotion:)
        content = file.read.to_s
        rows = ::CSV.parse(content, headers: false)

        validate_codes!(rows)

        ::Spree::PromotionBatch.create!(
          template_promotion: template_promotion,
          codes: rows.map(&:first)
        )

        # TODO: populate promotion batch
      end

      private

      def validate_codes!(rows)
        raise Error, 'Input cannot be empty' if rows.empty?
        raise Error, 'Rows should only contain promo codes' if rows.any? { |e| e.size != 1 }
      end
    end
  end
end
