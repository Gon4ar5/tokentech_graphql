# frozen_string_literal: true

module TokentechGraphql
  module Graphql
    module Interfaces
      module BaseInterface
        include GraphQL::Schema::Interface

        field_class Graphql::Types::BaseField
      end
    end
  end
end
