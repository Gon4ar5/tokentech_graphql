# frozen_string_literal: true

module TokentechGraphql
  module GraphqlApi
    module Enums
      # Sort order direction enum
      class OrderDirection < Graphql::Enums::BaseEnum
        description 'Represents sorting order direction, can be either ascending or descending'

        value 'ASC', value: 'asc'
        value 'DESC', value: 'desc'
      end
    end
  end
end
