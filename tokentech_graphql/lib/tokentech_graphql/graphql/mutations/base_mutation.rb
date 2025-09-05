# frozen_string_literal: true

module TokentechGraphql
  module Graphql
    module Mutations
      class BaseMutation < GraphQL::Schema::RelayClassicMutation
        argument_class Graphql::Inputs::BaseArgument
        input_object_class Graphql::Inputs::BaseInputObject
        field_class Graphql::Types::BaseField
        object_class Graphql::Mutations::BaseMutationObject

        null false
      end
    end
  end
end
