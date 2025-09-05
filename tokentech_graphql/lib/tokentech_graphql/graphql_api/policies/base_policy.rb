module TokentechGraphql
  module GraphqlApi
    module Policies
      class BasePolicy < Graphql::Policies::BasePolicy
        class << self
          attr_reader :authorized_proc, :default_field_authorization_proc

          def authorized(&block)
            raise ArgumentError, 'Type authorization is already defined' if @authorized_proc

            @authorized_proc = block
          end

          def default_field_authorization(&block)
            raise ArgumentError, 'Default field authorization is already defined' if @default_field_authorization_proc

            @default_field_authorization_proc = block
          end

          def authorize_field(field, &block)
            raise ArgumentError, 'Field should be a Symbol' unless field.is_a?(Symbol)

            check_already_authorized!(field)
            field_authorizers[field] = block
          end

          def public_field(field)
            raise ArgumentError, 'Field should be a Symbol' unless field.is_a?(Symbol)

            check_already_authorized!(field)
            field_authorizers[field] = :public
          end

          def field_authorizers
            @field_authorizers ||= {}
          end

          private

          def check_already_authorized!(field)
            raise(ArgumentError, "Authorization for `#{field}` is already defined") if field_authorizers.key?(field)
          end
        end

        attr_reader :object, :context

        def initialize(object, context)
          @object = object
          @context = context
        end

        def authorized?
          return true unless self.class.authorized_proc

          instance_exec(&self.class.authorized_proc)
        end

        def field_authorized?(field)
          raise ArgumentError, 'Field should be a Symbol' unless field.is_a?(Symbol)

          authorizer = self.class.field_authorizers[field]
          return field_authorized_by_default? unless authorizer

          authorizer == :public || instance_exec(&authorizer)
        end

        def field_authorized_by_default?
          return true unless self.class.default_field_authorization_proc

          instance_exec(&self.class.default_field_authorization_proc)
        end
      end
    end
  end
end
