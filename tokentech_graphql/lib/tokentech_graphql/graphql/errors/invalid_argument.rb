# frozen_string_literal: true

module TokentechGraphql
  module Graphql
    module Errors
      class InvalidArgument < BaseExecutionError
        def initialize(argument_name = nil, message: nil)
          if message.blank?
            message = 'Invalid value'
            message += " for `#{argument_name}`" if argument_name.present?
          end

          extensions = { code: 'INVALID_ARGUMENT' }
          extensions[:argument] = argument_name if argument_name.present?

          super(message, extensions: extensions)
        end
      end
    end
  end
end
