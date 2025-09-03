# frozen_string_literal: true

module GraphqlApi
  class PeatioSchema < GraphQL::Schema
    VERBOSE_ERRORS = Rails.env.development? || ENV['DEBUG_GRAPHQL_APIV2_VERBOSE_ERRORS'].to_boolean
    private_constant :VERBOSE_ERRORS

    use Okft::Graphql::Plugins::ErrorsHandler,
        verbose: VERBOSE_ERRORS,
        reraise_uknown: Rails.env.test?

    # Uncomment for in-depth debug:
    # use GraphQL::Backtrace if Rails.env.development? || Rails.env.test?

    # use GraphQL::Subscriptions::ActionCableSubscriptions
    use GraphQL::AnyCable, broadcast: true

    disable_introspection_entry_points unless AppEnv.graphql_v2.introspection_enabled?

    trace_with GraphqlApi::Tracing::CheckUserAllowedHost unless AllowedHostService.skip?

    query Types::QueryType
    mutation Types::MutationType
    subscription Types::SubscriptionType

    orphan_types Types::UserNotificationPlainType,
                 Types::UserNotificationNextActionRedirectType

    def self.unauthorized_object(error)
      raise Okft::Graphql::Errors::NotAuthorizedError, "Not authorized (#{error.type.graphql_name})"
    end

    def self.type_error(err, _context)
      # if err.is_a?(GraphQL::InvalidNullError)
      #   # report to your bug tracker here
      #   return nil
      # end
      super
    end

    # Union and Interface Resolution
    def self.resolve_type(abstract_type, object, _context)
      # type_class =
      #   case object
      #   when <model/entity class> then <gql type class>
      #   end

      # return type_class if type_class < Okft::Graphql::Types::BaseType

      if VERBOSE_ERRORS
        message = 'Cannot resolve object to a concrete GQL type'
        extensions = {
          abstract_type: abstract_type.name,
          object_type: object.class.name
        }
      end

      # TODO: report error to Sentry
      raise Okft::Graphql::Errors::InternalServerError.new(message, extensions:)
      # raise GraphQL::RequiredImplementationMissingError
    end

    def self.encode_id(value, type_definition)
      Support::Id.encode(value, type_definition)
    end

    # TODO: refactor into a mapper
    def self.object_id_type(object, fallback_type = nil)
      klass = object.is_a?(Class) ? object : object.class
      return Types::Interfaces::UserNotification if klass == ::AppNotification

      fallback_type
    end

    def self.object_id_method(object)
      klass = object.is_a?(Class) ? object : object.class
      return :uid if klass == ::AppNotification

      :id
    end

    def self.id_from_object(object, type_definition, _context)
      id = object.public_send(object_id_method(object))
      type = object_id_type(object, type_definition)
      Support::Id.encode(id, type)
    end

    def self.object_from_id(input_id, _context, **_options)
      begin
        id = Support::Id.decode(input_id)
      rescue Support::Id::DecodingError => e
        # TODO: report warning (?)
        raise Okft::Graphql::Errors::InvalidArgument.new(message: 'Invalid ID value')
      end

      unless type_class = get_type(id.type)
        # TODO: report warning
        raise Okft::Graphql::Errors::InvalidArgument.new(message: "Invalid type `#{id.type}`")
      end

      # TODO: refactor into a mapper
      model_class =
        case
        when type_class == Types::Interfaces::UserNotification then ::AppNotification
        else raise Okft::Graphql::Errors::ExecutionError, "Unresolvable type `#{id.type}`"
        end

      id_column = object_id_method(model_class)
      model_class.find_by!(id_column => id.value)
    end
  end
end
