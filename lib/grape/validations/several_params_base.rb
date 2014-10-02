module Grape
  module Validations
    class SeveralParamsBase < Validator
      attr_reader :scoped_params

      def validate!(params)
        @scoped_params = [@scope.params(params)].flatten
        params
      end

      private

      def scope_requires_params
        return true if @scope.required?
        scoped_params.each do |resource_params|
          return true unless resource_params.length == 0
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
