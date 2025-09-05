module TokentechGraphql
  module GraphqlApi
    module Mutations
      class BaseMutation < GraphQL::Schema::RelayClassicMutation
        include Concerns::HasCurrentUser
        argument_class Graphql::Inputs::BaseArgument
        input_object_class Graphql::Inputs::BaseInputObject
        field_class TokentechGraphql::Graphql::Types::BaseField
        object_class Graphql::Mutations::BaseMutationObject

        null false
      end
    end
  end
end
