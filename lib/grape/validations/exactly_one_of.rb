module Grape
  module Validations
    require 'grape/validations/mutual_exclusion'
    class ExactlyOneOfValidator < MutualExclusionValidator
      attr_reader :params

      def validate!(params)
        super
        if none_of_restricted_params_is_present
          raise Grape::Exceptions::Validation, params: all_keys, message_key: :exactly_one
        end
        params
      end

      private

      def none_of_restricted_params_is_present
        params.each do |resource_params|
          return true if keys_in_common(resource_params).length < 1
        end
        false
      end
    end
  end
end
