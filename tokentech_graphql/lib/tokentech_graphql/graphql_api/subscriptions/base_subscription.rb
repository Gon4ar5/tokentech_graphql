module TokentechGraphql
  module GraphqlApi
    module Subscriptions
      class BaseSubscription < GraphQL::Schema::Subscription
        extend Concerns::SchemaMethod
        include Concerns::HasCurrentUser

        object_class Graphql::Types::BaseObject
        field_class TokentechGraphql::Graphql::Types::BaseField
        argument_class TokentechGraphql::Graphql::Inputs::BaseArgument
      end
    end
  end
end
