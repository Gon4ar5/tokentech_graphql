module GraphqlApi
  module Connections
    class BaseConnection < Okft::Graphql::Connections::BaseConnection
      include Concerns::HasCurrentUser

      attr_reader :object
    end
  end
end
