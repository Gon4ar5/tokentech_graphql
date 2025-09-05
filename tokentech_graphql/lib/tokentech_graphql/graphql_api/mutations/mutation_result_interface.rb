# frozen_string_literal: true

module TokentechGraphql
  module GraphqlApi
    module Interfaces
      module MutationResultInterface
        include BaseInterface

        graphql_name 'MutationResult'

        field :success, Boolean, null: false
      end
    end
  end
end
