# frozen_string_literal: true

module TokentechGraphql
  module GraphqlApi
    module Concerns
      # Provides the ability to quickly access the main schema class via the `schema` method
      # in cases when query context is not available.
      #
      # Solves the issue with circular dependencies when attempting to access schema via const.
      #
      module SchemaMethod
        def schema
          ::GraphqlApi::PeatioSchema
        end
      end
    end
  end
end