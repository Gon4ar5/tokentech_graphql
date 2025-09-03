# frozen_string_literal: true

module GraphqlApi
  module Concerns
    # TODO: possibly refactor to move to `lib`

    # Provides the ability to easily create namespaces in a GQL mutation query type
    # by auto-generating namespace field including its name, resolver and GQL type
    # 
    #   class MutationType < BaseObject
    #     extend NamespacedMutations
    #
    #     namespace :books do
    #       field :create, mutation: Mutations::Books::CreateMutation, null: true
    #     end
    #   end
    #
    # This structures the API according to the following query:
    #
    #   mutation CreateBook {
    #     books {
    #       create(authorId: "MTIzNDU2") { ... }
    #     }
    #   }
    #    
    module NamespacedMutations
      def namespace(identifier, &block)
        klass = Class.new(Okft::Graphql::Types::BaseObject) do
          graphql_name "#{identifier.to_s.camelize}Mutations"
          class_eval(&block)
        end

        field identifier, klass, null: false
        define_method(identifier) { {} } # field resolver
      end
    end
  end
end
