# frozen_string_literal: true

module TokentechGraphql
  module GraphqlApi
    module Errors
      class BaseExecutionError < ::GraphQL::ExecutionError
        def initialize(message, ast_node: nil, options: nil, extensions: nil)
          extensions ||= { code: 'GENERIC_ERROR' }
          super
        end
      end
    end
  end
end
