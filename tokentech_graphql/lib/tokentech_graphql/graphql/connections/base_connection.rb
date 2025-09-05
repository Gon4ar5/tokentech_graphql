# frozen_string_literal: true

module TokentechGraphql
  module Graphql
    module Connections
      class BaseConnection
        extend Memoist

        include Concerns::ObjectValidation

        def initialize(object, context, arguments = nil)
          validate_object!(object)

          @object = object
          @context = context
          @arguments = arguments
        end

        memoize def pagination
          @arguments[:pagination] if @arguments
        end

        def pagination?
          !pagination.nil? && !pagination[:offset].nil? && !pagination[:limit].nil?
        end

        memoize def filter
          (@arguments && @arguments[:filter]) || {}
        end

        memoize def order
          @arguments[:order] if @arguments
        end

        def order?
          !order.nil? && !order[:direction].nil? && !order[:field].nil?
        end

        def filter_scope_by_states(scope)
          return scope if filter[:states].blank?

          scope.where(aasm_state: filter[:states])
        end

        def paginate_scope(scope)
          return scope unless pagination?

          scope.offset(pagination[:offset]).limit(pagination[:limit])
        end

        def paginate_array(array)
          return array unless pagination?

          array.slice(pagination[:offset], pagination[:limit]) || []
        end

        def order_scope(scope)
          return scope unless order?

          scope.reorder(order[:field] => order[:direction])
        end
      end
    end
  end
end
