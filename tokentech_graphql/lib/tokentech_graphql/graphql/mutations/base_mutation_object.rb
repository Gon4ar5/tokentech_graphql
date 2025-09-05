# frozen_string_literal: true

module TokentechGraphql
  module Graphql
    module Mutations
      class BaseMutationObject < GraphQL::Schema::Object
        field_class Graphql::Types::BaseField
        implements Graphql::Interfaces::MutationResultInterface
      end
    end
  end
end
