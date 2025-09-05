# frozen_string_literal: true

module TokentechGraphql
  module GraphqlApi
    module Inputs
      class BaseInputObject < GraphQL::Schema::InputObject
        argument_class Graphql::Inputs::BaseArgument
      end
    end
  end
end
