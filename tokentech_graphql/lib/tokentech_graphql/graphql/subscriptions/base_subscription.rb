# frozen_string_literal: true

module TokentechGraphql
  module Graphql
    module Subscriptions
      class BaseSubscription < GraphQL::Schema::Subscription
        object_class TokentechGraphql::Graphql::Types::BaseObject
        field_class TokentechGraphql::Graphql::Types::BaseField
        argument_class TokentechGraphql::Graphql::Inputs::BaseArgument
      end
    end
  end
end
