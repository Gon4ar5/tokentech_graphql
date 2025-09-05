module TokentechGraphql
  module GraphqlApi
    module Types
      class MutationType < Graphql::Types::BaseObject
        extend GraphqlApi::Concerns::NamespacedMutations

        namespace :user_notifications do
          field :mark_all_as_viewed, mutation: Mutations::UserNotifications::MarkAllAsViewedMutation, null: true
          field :mark_as_viewed, mutation: Mutations::UserNotifications::MarkAsViewedMutation, null: true
        end

        # def self.authorized?(_object, _context)
        #   true
        # end
      end
    end
  end
end
