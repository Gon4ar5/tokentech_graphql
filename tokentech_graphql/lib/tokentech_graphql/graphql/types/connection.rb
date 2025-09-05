# frozen_string_literal: true

module TokentechGraphql
  module Graphql
    module Types
      class Connection
        class Default < BaseObject
        end

        class << self
          def default(type_class, graphql_name: nil)
            class_name = graphql_class_name(type_class, graphql_name)

            with_cache(class_name, type_class, Default) do |base_connection_class|
              Class.new(base_connection_class) do
                graphql_name class_name

                field :nodes, [type_class], null: false
                field :total_count, Integer, null: false
              end
            end
          end

          private

          def with_cache(class_name, type_class, base_connection_class)
            if type_class.constants.map(&:to_s).include?(class_name)
              type_class.const_get(class_name).tap do |cached_class|
                validate_cached_superclass!(cached_class, base_connection_class, class_name)
              end
            else
              yield(base_connection_class).tap do |created_class|
                type_class.const_set(class_name, created_class)
              end
            end
          end

          def graphql_class_name(type_class, graphql_name)
            return graphql_name unless graphql_name.nil?

            "#{type_class.graphql_name}Connection"
          end

          def validate_cached_superclass!(cached_connection_class, base_connection_class, class_name)
            return if cached_connection_class.superclass == base_connection_class

            raise ArgumentError, <<~MESSAGE.strip
              The #{class_name} class already defined but with other base connection class.
              Expected: #{base_connection_class}
              Received: #{cached_connection_class.superclass}
            MESSAGE
          end
        end
      end
    end
  end
end
