module TokentechGraphql
  module GraphqlApi
    module Types
      class QueryType < BaseType
        # include GraphQL::Types::Relay::HasNodeField
        # include GraphQL::Types::Relay::HasNodesField

        field :viewer, Types::ViewerType, null: false

        def viewer
          {}
        end
      end
    end
  end
end
