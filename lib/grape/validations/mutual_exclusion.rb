module Grape
  module Validations
    require 'grape/validations/several_params_base'
    class MutualExclusionValidator < SeveralParamsBase
      attr_reader :processing_keys_in_common

      def validate!(params)
        super
        if two_or_more_exclusive_params_are_present
          raise Grape::Exceptions::Validation, params: processing_keys_in_common, message_key: :mutual_exclusion
        end
        params
      end

      private

      def two_or_more_exclusive_params_are_present
        scoped_params.each do |resource_params|
          @processing_keys_in_common = keys_in_common(resource_params)
          return true if @processing_keys_in_common.length > 1
        end
        false
      end
    end
  end
end
