module GraphqlApi
  module Mutations
    module UserNotifications
      class MarkAsViewedMutation < BaseMutation
        graphql_name 'MarkUserNotificationAsViewed'

        argument :ids, [ID], required: true

        field :notifications,
              [Types::Interfaces::UserNotification],
              null: false,
              description: 'Notifications affected by the mutation'
        field :total_unread_count, Integer, null: false

        def resolve(ids:)
          uids = ids.map { |id| Support::Id.decode(id, Types::Interfaces::UserNotification).value }
          perform_action!(uids:)

          {
            success: true,
            # TODO: use AOT analysis, so that notifications are not returned when not queried
            notifications: current_user.app_notifications.where(uid: @result.uids).ordered.to_a,
            total_unread_count: @result.unread_count
          }
        end

        def ready?(**_args)
          return true if current_user

          raise Okft::Graphql::Errors::NotAuthorizedError, 'Not authorized'
        end

        private

        def perform_action!(uids:)
          params = { member: current_user, uids: }
          @result = ::AppNotifications::MarkAsViewedAndNotify.call(**params)
          raise 'unexpected AppNotification update fail' unless @result.success?
        end
      end
    end
  end
end
