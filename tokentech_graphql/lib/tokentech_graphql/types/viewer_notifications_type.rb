module GraphqlApi
  module Types
    class ViewerNotificationsType < BaseType
      field :groups, [ViewerUserNotificationGroupType], null: false
      field :total_unread_count, Integer, null: false
      field :items, Okft::Graphql::Types::Connection.default(GraphqlApi::Types::Interfaces::UserNotification), null: true do
        argument :pagination, Okft::Graphql::Inputs::OffsetPagination
        argument :filter, GraphqlApi::Inputs::UserNotificationsFilter
      end

      def groups
        AppNotification.groups_with_all.map do |group_identifier|
          {
            identifier: group_identifier,
            title: AppNotification.group_name_by(group_identifier, current_user&.lang),
            icon_url: AppNotification.group_icon_url_by(group_identifier)
          }
        end
      end

      def total_unread_count
        current_user&.app_notifications&.unread&.count || 0
      end

      def items(**arguments)
        Connections::UserNotifications.new(current_user, context, arguments) if current_user
      end
    end
  end
end
