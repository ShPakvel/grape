module Grape
  module Validations
    require 'grape/validations/mutual_exclusion'
    class ExactlyOneOfValidator < MutualExclusionValidator
      def validate!(params)
        super
        if scope_requires_params && none_of_restricted_params_is_present
          raise Grape::Exceptions::Validation, params: all_keys, message_key: :exactly_one
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

      def none_of_restricted_params_is_present
        scoped_params.each do |resource_params|
          return true if keys_in_common(resource_params).length < 1
        end
        false
      end
    end
  end
end
