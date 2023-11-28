module Spree
  module Promotions
    class CodeGenerator
      def initialize(config = {})
        @config = config
      end

      def build
        loop do
          candidate = compose
          break candidate if valid?(candidate)
        end
      end

      private

      attr_reader :config

      def valid?(subject)
        return true if config[:deny_list].nil?

        violation_checks = config[:deny_list].map do |el|
          subject.include?(el)
        end

        !violation_checks.any?
      end

      def compose
        case config[:affix]
        when :prefix
          prefix_alorithm
        when :suffix
          suffix_alorithm
        else
          default_algorithm
        end
      end

      def prefix_alorithm
        content.concat(random_code)
      end

      def suffix_alorithm
        random_code.concat(content)
      end

      def default_algorithm
        random_code
      end

      def content
        config[:content]
      end

      def random_code
        SecureRandom.hex(4)
      end
    end
  end
end
