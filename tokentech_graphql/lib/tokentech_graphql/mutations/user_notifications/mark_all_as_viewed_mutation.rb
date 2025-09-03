module GraphqlApi
  module Mutations
    module UserNotifications
      class MarkAllAsViewedMutation < BaseMutation
        graphql_name 'MarkAllUserNotificationAsViewed'

        argument :before,
                 GraphQL::Types::ISO8601DateTime,
                 required: true,
                 description: "Date of the last notification known to the client. New notifications that may appear " \
                              "during execution of this action (for example, due to request round-trip delay) " \
                              "after the specified date will not be marked as viewed"
        argument :group_identifier,
                 Enums::UserNotificationGroupIdentifier,
                 required: true,
                 description: 'Only those notifications that are included in the specified group ' \
                              'will be marked as viewed'

        field :total_unread_count, Integer, null: false

        def resolve(before:, group_identifier:)
          perform_action!(before:, group_identifier:)

          {
            success: true,
            total_unread_count: @result.unread_count
          }
        end

        def ready?(**_args)
          return true if current_user

          raise Okft::Graphql::Errors::NotAuthorizedError, 'Not authorized'
        end

        private

        def perform_action!(before:, group_identifier:)
          params = {
            member: current_user,
            before: before.in_time_zone,
            group: group_identifier
          }
          @result = ::AppNotifications::MarkAllAsViewedAndNotify.call(**params)
          raise 'unexpected AppNotification update fail' unless @result.success?
        end
      end
    end
  end
end
