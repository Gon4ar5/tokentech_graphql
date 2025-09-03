module GraphqlApi
  module Subscriptions
    class UserNotificationsUpdated < BaseSubscription
      class AllMarkedAsViewedType < Types::BaseType
        graphql_name 'UserNotificationsUpdatedAllMarkedAsViewed'

        description 'Represents data corresponding to an event triggered by `markAllAsViewed` mutation'

        Entity = Struct.new(:before, :group_identifier, keyword_init: true)

        field :before,
              GraphQL::Types::ISO8601DateTime,
              null: false,
              description: 'All user notifications prior to this date (UserNotification.createdAt <= before) ' \
                           'have been marked as viewed'

        field :group_identifier,
              Enums::UserNotificationGroupIdentifier,
              null: false,
              description: 'Only those notifications included in this group were marked as viewed'
      end

      Entity = Struct.new(:all_marked_as_viewed, :new_notifications, :marked_as_viewed_ids,
                          :total_unread_count, keyword_init: true)

      subscription_scope :current_user_id

      field :all_marked_as_viewed,
            AllMarkedAsViewedType,
            null: true,
            description:
              'Contains info about multiple user notifications that have been marked as viewed (for example, ' \
              'due to `markAllAsViewed` mutation call from a separate browser tab or another device). In such ' \
              "a case, the client must update its cache by itself accordingly.\n\n" \
              'Should be ignored if value is `null`.'

      field :new_notifications,
            [Types::Interfaces::UserNotification],
            null: true,
            description: 'Contains new user notifications as they arrive. Should be ignored if value is `null`.'

      field :marked_as_viewed_ids,
            [ID],
            null: true,
            description:
              'Contains IDs of user notifications that have been marked as viewed (for example, due to ' \
              '`markAsViewed` mutation call from a separate browser tab or another device). In such a case, ' \
              "the client must update its cache by itself accordingly.\n\n" \
              'Should be ignored if value is `null`.'

      field :total_unread_count,
            Integer,
            null: true,
            description: 'Should be ignored if value is `null`'

      def self.trigger(for_user:, marked_as_viewed_uids: nil, **args)
        payload = args.compact

        if marked_as_viewed_uids.present?
          payload[:marked_as_viewed_ids] = marked_as_viewed_uids.uniq.map do |uid|
            schema.encode_id(uid, Types::Interfaces::UserNotification)
          end
        end

        if payload[:all_marked_as_viewed].present?
          payload[:all_marked_as_viewed] = AllMarkedAsViewedType::Entity.new(payload[:all_marked_as_viewed])
        end

        payload[:total_unread_count] ||= for_user.app_notifications_unread_count

        payload = Entity.new(payload)
        schema.subscriptions.trigger(:user_notifications_updated, {}, payload, scope: for_user.id)
      end

      def authorized?
        # TODO: denies access silently on anycable

        # TODO: check user level & agreements acceptance (?)
        return true if current_user.present?

        raise Okft::Graphql::Errors::NotAuthorizedError, 'Not authorized'
      end
    end
  end
end
