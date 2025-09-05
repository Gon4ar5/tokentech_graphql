# frozen_string_literal: true

module TokentechGraphql
  module GraphqlApi
    module Inputs
      class OrderInput
        class << self
          # Creates an order input based on the passed enum
          #
          # @example
          #   argument :order, Inputs::Order.create(Enums::DepositOrderField), required: true
          def create(order_field_enum_class, graphql_name: nil, cache: true, base_input_class: BaseInputObject)
            unless order_field_enum_class < GraphQL::Schema::Enum
              raise ArgumentError, "#{order_field_enum_class.name} is not a GraphQL enum"
            end

            unless base_input_class < GraphQL::Schema::InputObject
              raise ArgumentError, "#{base_input_class.name} is not a GraphQL input object"
            end

            class_name = graphql_name || graphql_name_from_enum(order_field_enum_class)

            with_cache(class_name, order_field_enum_class, base_input_class, enabled: cache) do
              Class.new(base_input_class) do
                graphql_name class_name

                argument :direction, Enums::OrderDirection, required: true
                argument :field, order_field_enum_class, required: true
              end
            end
          end

          private

          def with_cache(class_name, order_field_enum_class, base_input_class, enabled: true)
            if enabled && order_field_enum_class.constants.map(&:to_s).include?(class_name)
              order_field_enum_class.const_get(class_name).tap do |cached_class|
                validate_cached_superclass!(cached_class, base_input_class, class_name)
              end
            else
              yield(base_input_class).tap do |created_class|
                order_field_enum_class.const_set(class_name, created_class) if enabled
              end
            end
          end

          def graphql_name_from_enum(enum_class)
            enum_class_name = enum_class.name.demodulize

            unless enum_class_name.ends_with?('OrderField')
              raise ArgumentError, 'Specified enum class name should end with "OrderField"'
            end

            enum_class_name.gsub(/Field$/, '')
          end

          def validate_cached_superclass!(cached_input_class, base_input_class, class_name)
            return if cached_input_class.superclass == base_input_class

            raise ArgumentError, <<~MESSAGE.strip
              The #{class_name} class already defined but with other base input class.
              Expected: #{base_input_class}
              Received: #{cached_input_class.superclass}
            MESSAGE
          end
        end
      end
    end
  end
end
