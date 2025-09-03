module GraphqlApi
  module Connections
    class UserNotifications < BaseConnection
      object_type Member

      def nodes
        paginate_scope(relevant_scope).ordered.to_a
      end

      def total_count
        relevant_scope.count
      end

      private

      memoize def relevant_scope
        object.app_notifications.all
              .then(&method(:filter_by_group))
              .then(&method(:filter_by_viewed))
              # .then(&method(:order_scope))
      end

      def filter_by_group(scope)
        return scope unless filter[:group_identifier] && (filter[:group_identifier] != 'all')

        scope.public_send(filter[:group_identifier])
      end

      def filter_by_viewed(scope)
        return scope unless filter[:unread_only]

        scope.unread
      end
    end
  end
end
