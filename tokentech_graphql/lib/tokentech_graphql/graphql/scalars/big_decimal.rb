# frozen_string_literal: true

module TokentechGraphql
  module Graphql
    module Scalars
      class BigDecimal < BaseScalar
        description 'Decimal number'

        def self.coerce_input(input, _context)
          return nil unless input.present?

          BigDecimal(input.to_s)
        rescue ArgumentError
          raise GraphQL::CoercionError, "Cannot coerce `#{input.to_s}` to BigDecimal"
        end

        def self.coerce_result(number, _context)
          return unless number.present?

          BigDecimal(number.to_s).to_s

          # We can't rescue from ArgumentError here since it occurs in the graphql layer and is not
          # handled by `rescue_from` similarly to an error in the application layer.
          # Details: https://github.com/rmosolgo/graphql-ruby/blob/7939e1439620026f960d9e2e930c7be75715e081/lib/graphql/execution/interpreter/runtime.rb#L753-L760
          #
          # Possible solutions:
          # 1. Implement a gem fix
          # 2. Implement generic handler utilizing `context.add_error`
          #
          # For now we let the whole query fail so that the error is reported and we can fix the root cause later
        end
      end
    end
  end
end
