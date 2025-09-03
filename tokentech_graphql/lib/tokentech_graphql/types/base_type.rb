module GraphqlApi
  module Types
    class BaseType < Okft::Graphql::Types::BaseType
      include Concerns::HasCurrentUser
    end
  end
end
