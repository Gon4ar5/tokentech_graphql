module GraphqlApi
  module Types
    class UserNotificationPlainType < BaseType
      implements GraphqlApi::Types::Interfaces::UserNotification
    end
  end
end
