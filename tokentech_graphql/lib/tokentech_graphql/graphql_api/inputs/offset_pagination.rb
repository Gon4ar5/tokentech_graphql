# frozen_string_literal: true

module TokentechGraphql
  module GraphqlApi
    module Inputs
      class OffsetPagination < BaseInputObject
        description 'Input for slicing array-like data'

        argument :offset, Integer, required: true, description: 'Offset for results'
        argument :limit, Integer, required: true, description: 'Limit number of results'
      end
    end
  end
end
