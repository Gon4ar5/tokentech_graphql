module GraphqlApi
  module Subscriptions
    class BaseSubscription < Okft::Graphql::Subscriptions::BaseSubscription
      extend Concerns::SchemaMethod
      include Concerns::HasCurrentUser
    end
  end
end
