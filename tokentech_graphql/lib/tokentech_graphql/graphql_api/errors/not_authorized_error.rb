# frozen_string_literal: true

module TokentechGraphql
  module GraphqlApi
    module Errors
      class NotAuthorizedError < BaseExecutionError
        def initialize(message, extensions: nil)
          extensions ||= {}
          extensions[:code] = 'UNAUTHORIZED'
          super(message, extensions: extensions)
        end
      end
    end
  end
end
