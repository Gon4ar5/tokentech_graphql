module GraphqlApi
  module Types
    class ViewerUserNotificationGroupType < BaseType
      field :identifier, Enums::UserNotificationGroupIdentifier, null: false
      field :title, String, null: false
      field :icon_url, String, null: false
    end
  end
end
