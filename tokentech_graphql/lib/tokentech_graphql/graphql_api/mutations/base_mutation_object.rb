# frozen_string_literal: true

module TokentechGraphql
  module GraphqlApi
    module Mutations
      class BaseMutationObject < GraphQL::Schema::Object
        field_class TokentechGraphql::Graphql::Types::BaseField
        implements Graphql::Interfaces::MutationResultInterface
      end
    end
  end
end
