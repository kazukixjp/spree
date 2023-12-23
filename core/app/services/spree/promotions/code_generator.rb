module Spree
  module Promotions
    class CodeGenerator
      MutuallyExclusiveInputsError = Class.new(StandardError)
      RetriesDepleted = Class.new(StandardError)

      def initialize(config = {})
        @config = config
      end

      def build
        validate_inputs if config[:deny_list]
        success = false
        result = 100.times do
          candidate = compose
          if valid?(candidate)
            success = true
            break candidate
          end
        end
        success ? result : raise(RetriesDepleted)
      end

      private

      attr_reader :config

      def validate_inputs
        raise_error if inputs_invalid?
      end

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
        clear_result.concat(content, random_code)
      end

      def suffix_alorithm
        clear_result.concat(random_code, content)
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

      def clear_result
        result = ""
      end

      def raise_error
        raise MutuallyExclusiveInputsError, Spree.t(:mutually_exclusive_inputs)
      end

      def inputs_invalid?
        config[:deny_list].include?(content)
      end
    end
  end
end
