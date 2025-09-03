module GraphqlApi
  module Types
    module Interfaces
      module UserNotification
        include BaseInterface

        global_id_field :id

        field :viewed, Boolean, null: false
        field :group, ViewerUserNotificationGroupType, null: false
        field :title, String, null: false
        field :icon_url, String, null: true
        field :message, String, null: false
        field :created_at, GraphQL::Types::ISO8601DateTime, null: false
        field :next_action, Unions::UserNotificationNextAction, null: true

        definition_methods do
          def resolve_type(_object, _context)
            GraphqlApi::Types::UserNotificationPlainType
            # if object.action_type
            #   GraphqlApi::Types::UserNotificationWithActionType
            # else
            #   GraphqlApi::Types::UserNotificationPlainType
            # end
          end
        end

        def group
          {
            identifier: object.group,
            title: object.group_title,
            icon_url: object.group_icon_url
          }
        end

        def icon_url
          object.group_icon_url
        end
      end
    end
  end
end
