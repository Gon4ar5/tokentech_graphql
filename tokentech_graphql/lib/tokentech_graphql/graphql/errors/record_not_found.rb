# frozen_string_literal: true

module TokentechGraphql
  module Graphql
    module Errors
      class RecordNotFound < BaseExecutionError
        def initialize(extensions: nil)
          extensions ||= {}
          extensions[:code] = 'RECORD_NOT_FOUND'
          super('Record not found', extensions: extensions)
        end
      end
    end
  end
end
