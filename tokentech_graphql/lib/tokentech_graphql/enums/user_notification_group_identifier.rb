module GraphqlApi
  module Enums
    class UserNotificationGroupIdentifier < BaseEnum
      AppNotification.groups_with_all.each do |group_identifier|
        value group_identifier.to_s.upcase, value: group_identifier.to_s
      end
    end
  end
end
