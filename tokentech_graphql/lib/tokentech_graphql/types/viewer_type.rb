module GraphqlApi
  module Types
    class ViewerType < BaseType
      object_type Hash

      field :notifications, ViewerNotificationsType, null: true, description: 'Viewer notifications'

      def notifications
        {}
      end
    end
  end
end
