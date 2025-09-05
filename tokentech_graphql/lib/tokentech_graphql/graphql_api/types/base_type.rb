module TokentechGraphql
  module GraphqlApi
    module Types
      class BaseType < GraphQL::Schema::Field
        include TokentechGraphql::GraphqlV2::GraphqlApi::Concerns::HasCurrentUser
        # Supresses default connections decoration. See:      
        # https://github.com/rmosolgo/graphql-ruby/blob/27762aa781de5c98039098ca5eaf6bb3fa86702f/lib/graphql/schema/field.rb#L141
        # https://github.com/rmosolgo/graphql-ruby/blob/27762aa781de5c98039098ca5eaf6bb3fa86702f/lib/graphql/schema/field.rb#L319-L320
        # https://github.com/rmosolgo/graphql-ruby/blob/732f223f18e6e6478f086e9e6112a8bb9fa35eeb/lib/graphql/schema/field/connection_extension.rb#L7-L12
        def connection?
          @connection.nil? ? false : @connection
        end

        def authorized?(object, _args, context)
          current_type = context[:current_object].class
          policy_class = current_type.try(:policy_class)
          return true unless policy_class

          policy = policy_class.new(object, context)
          policy.field_authorized?(original_name)
        end
      end
    end
  end
end
