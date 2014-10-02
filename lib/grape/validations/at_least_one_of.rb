module Grape
  module Validations
    class AtLeastOneOfValidator < Validator
      attr_reader :params

      def validate!(params)
        @params = [@scope.params(params)].flatten
        if no_exclusive_params_are_present
          raise Grape::Exceptions::Validation, params: all_keys, message_key: :at_least_one
        end
        params
      end

      private

      def no_exclusive_params_are_present
        params.each do |resource_params|
          return true if keys_in_common(resource_params).length == 0
        end
        false
      end

      def keys_in_common(params)
        (all_keys & params.stringify_keys.keys).map(&:to_s)
      end

      def all_keys
        attrs.map(&:to_s)
      end
    end
  end
end
