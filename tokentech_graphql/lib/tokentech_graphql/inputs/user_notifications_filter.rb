module GraphqlApi
  module Inputs
    class UserNotificationsFilter < BaseInput
      argument :group_identifier, Enums::UserNotificationGroupIdentifier, required: true
      argument :unread_only, Boolean, required: false
    end
  end
end
