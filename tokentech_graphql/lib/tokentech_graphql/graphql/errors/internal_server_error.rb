# frozen_string_literal: true

module TokentechGraphql
  module Graphql
    module Errors
      class InternalServerError < BaseExecutionError
        def initialize(message = nil, extensions: nil)
          message ||= 'Internal server error'
          extensions ||= {}
          extensions[:code] = 'INTERNAL_SERVER_ERROR'
          super(message, extensions: extensions)
        end
      end
    end
  end
end
