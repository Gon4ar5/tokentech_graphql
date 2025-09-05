# frozen_string_literal: true

module TokentechGraphql
  module Graphql
    module Types
      class BaseType < BaseObject
        include Concerns::ObjectValidation

        class << self
          attr_reader :policy_class

          def use_policy(klass)
            raise "policy class already set to #{@policy_class.name}" if @policy_class
        
            @policy_class = klass
          end

          def authorized?(object, context)
            return true unless @policy_class

            @policy_class.new(object, context).authorized?
          end
        end

        def initialize(object, context)
          validate_object!(object)
          super
        end
      end
    end
  end
end
