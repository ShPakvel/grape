module Grape
  module Validations
    require 'grape/validations/several_params_base'
    class AtLeastOneOfValidator < SeveralParamsBase
      def validate!(params)
        super
        if scope_requires_params && no_exclusive_params_are_present
          raise Grape::Exceptions::Validation, params: all_keys, message_key: :at_least_one
        end
        params
      end

      private

      def no_exclusive_params_are_present
        scoped_params.each do |resource_params|
          return true if keys_in_common(resource_params).length == 0
        end
        false
      end
    end
  end
end
