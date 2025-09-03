module GraphqlApi
  module Entities
    class BaseEntity
      extend Memoist
      include Concerns::HasCurrentUser
      include Okft::Graphql::Concerns::ObjectValidation

      def initialize(object, context)
        validate_object!(object)
        @object = object
        @context = context
      end
    end
  end
end
