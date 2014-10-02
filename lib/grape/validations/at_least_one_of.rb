module Grape
  module Validations
    class AtLeastOneOfValidator < Validator
      attr_reader :scoped_params

      def validate!(params)
        @scoped_params = [@scope.params(params)].flatten
        if scope_requires_params && no_exclusive_params_are_present
          raise Grape::Exceptions::Validation, params: all_keys, message_key: :at_least_one
        end
        params
      end

      private

      def scope_requires_params
        return true unless @scope.is_optional?
        scoped_params.each do |resource_params|
          return true unless resource_params.length == 0
        end
        false
      end

      def no_exclusive_params_are_present
        scoped_params.each do |resource_params|
          return true if keys_in_common(resource_params).length == 0
        end
        false
      end

      def keys_in_common(resource_params)
        (all_keys & resource_params.stringify_keys.keys).map(&:to_s)
      end

      def all_keys
        attrs.map(&:to_s)
      end
    end
  end
end
