module GraphqlApi
  module Mutations
    class BaseMutation < Okft::Graphql::Mutations::BaseMutation
      include Concerns::HasCurrentUser
    end
  end
end
