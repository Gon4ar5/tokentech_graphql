# frozen_string_literal: true

module TokentechGraphql
  module GraphqlApi
    module Types
      class BaseObject < GraphQL::Schema::Object
        field_class TokentechGraphql::Graphql::Types::BaseField
      end
    end
  end
end
