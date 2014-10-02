module Grape
  module Validations
    class MutualExclusionValidator < Validator
      attr_reader :params, :processing_keys_in_common

      def validate!(params)
        @params = [@scope.params(params)].flatten
        if two_or_more_exclusive_params_are_present
          raise Grape::Exceptions::Validation, params: processing_keys_in_common, message_key: :mutual_exclusion
        end
        params
      end

      private

      def two_or_more_exclusive_params_are_present
        params.each do |resource_params|
          @processing_keys_in_common = keys_in_common(resource_params)
          return true if @processing_keys_in_common.length > 1
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
