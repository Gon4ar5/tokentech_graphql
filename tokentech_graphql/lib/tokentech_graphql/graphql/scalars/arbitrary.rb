# frozen_string_literal: true

module TokentechGraphql
  module Graphql
    module Scalars
      class Arbitrary < BaseScalar
        description 'String or number'

        def self.coerce_input(input, _context)
          return input if supported_value_type?(input)

          raise GraphQL::CoercionError, "Value type of `#{input.to_s}` is not supported"
        end

        def self.coerce_result(value, _context)
          return value if supported_value_type?(value)

          raise TypeError, "Unexpected value type: #{value.class}"
        end

        def self.supported_value_type?(value)
          value.is_a?(Integer) || value.is_a?(String)
        end
        private_class_method :supported_value_type?
      end
    end
  end
end
