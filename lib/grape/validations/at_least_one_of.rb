module Grape
  module Validations
    class AtLeastOneOfValidator < Validator
      attr_reader :params

      def validate!(params)
        @params = @scope.params(params)
        if no_exclusive_params_are_present
          raise Grape::Exceptions::Validation, params: all_keys, message_key: :at_least_one
        end
        params
      end

      private

      def no_exclusive_params_are_present
        keys_in_common.length == 0
      end

      def keys_in_common
        (all_keys & params.stringify_keys.keys).map(&:to_s)
      end

      def all_keys
        attrs.map(&:to_s)
      end
    end
  end
end
