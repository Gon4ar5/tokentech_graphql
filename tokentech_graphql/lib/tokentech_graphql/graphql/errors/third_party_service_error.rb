# frozen_string_literal: true

module TokentechGraphql
  module Graphql
    module Errors
      # Error to raise in case the field cannot be resolved due to a third-party service issue,
      # e.g. during backend-to-backend communication
      class ThirdPartyServiceError < BaseExecutionError
        def initialize(message)
          super(message, extensions: { code: 'THIRD_PARTY_SERVICE_ERROR' })
        end
      end
    end
  end
end
