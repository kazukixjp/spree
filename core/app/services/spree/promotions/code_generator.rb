module Spree
  module Promotions
    class CodeGenerator
      def initialize(config = {})
        @config = config
      end

      def build
        compose
      end

      private

      def compose
        case @config[:affix]
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
        @config[:content]
      end

      def random_code
        SecureRandom.hex(4)
      end
    end
  end
end
