# frozen_string_literal: true

module TokentechGraphql
  module GraphqlApi
    module Interfaces
      module BaseInterface
        include GraphQL::Schema::Interface

        field_class TokentechGraphql::Graphql::Types::BaseField
      end
    end
  end
end
