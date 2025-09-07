# frozen_string_literal: true

module TokentechGraphql
  module Graphql
    module Types
      class BaseObject < GraphQL::Schema::Object
        field_class TokentechGraphql::Graphql::Types::BaseField
      end
    end
  end
end
