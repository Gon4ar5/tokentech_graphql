module GraphqlApi
  module Types
    class SubscriptionType < Okft::Graphql::Types::BaseObject
      field :user_notifications_updated, subscription: Subscriptions::UserNotificationsUpdated
    end
  end
end
