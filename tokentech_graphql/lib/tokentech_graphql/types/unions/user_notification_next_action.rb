module GraphqlApi
  module Types
    module Unions
      class UserNotificationNextAction < Okft::Graphql::Types::BaseUnion
        possible_types Types::UserNotificationNextActionRedirectType

        def self.resolve_type(object, _context)
          na_type = object['type']
          "GraphqlApi::Types::UserNotificationNextAction#{na_type.capitalize}Type".constantize
        end
      end
    end
  end
end
