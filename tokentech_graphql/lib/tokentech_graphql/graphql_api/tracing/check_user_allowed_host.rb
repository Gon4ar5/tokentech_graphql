module TokentechGraphql
  module GraphqlApi
    module Tracing
      # NOTE: keep this tracer compatible with GQL API v1
      module CheckUserAllowedHost
        def execute_query(query:)
          member = query.context[:current_user]
          if member && !query.subscription?
            ahs = AllowedHostService.new(member)
            unless ahs.current_host_allowed?
              raise GraphqlApi::Errors::WrongDomainError.new(redirect_to: ahs.redirect_to)
            end
          end

          yield
        end
      end
    end
  end
end
