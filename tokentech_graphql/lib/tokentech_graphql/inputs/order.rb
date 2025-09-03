module GraphqlApi
  module Inputs
    class Order < Okft::Graphql::Inputs::OrderInput
      class << self
        def create(order_field_enum_class, **options)
          options = { base_input_class: BaseInput }.merge(options)
          super(order_field_enum_class, **options)
        end
      end
    end
  end
end
