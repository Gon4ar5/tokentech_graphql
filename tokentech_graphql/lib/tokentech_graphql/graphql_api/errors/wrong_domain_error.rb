module TokentechGraphql
  module GraphqlApi
    module Errors
      # NOTE: keep this error compatible with GQL API v1
      class WrongDomainError < ::GraphQL::ExecutionError
        def initialize(redirect_to:)
          extensions = {
            code: 'WRONG_DOMAIN',
            redirect_to: {
              'domain' => redirect_to
            }
          }
          super('Wrong domain', extensions:)
        end
      end
    end
  end
end
