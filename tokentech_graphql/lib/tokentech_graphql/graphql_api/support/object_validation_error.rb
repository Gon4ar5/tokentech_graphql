# frozen_string_literal: true

module TokentechGraphql
  module GraphqlApi
    module Support
      class ObjectValidationError < TypeError
        def initialize(object, klass)
          @object = object
          @klass = klass
          super(generate_message)
        end

        private

        def generate_message
          if @object.is_a?(::Class)
            instance_or_class = 'class'
            object_class_name = @object.name
          else
            instance_or_class = 'an instance of'
            object_class_name = @object.class.name
          end

          "Object validation for #{@klass.name} failed (#{instance_or_class} #{object_class_name} was passed)"
        end
      end
    end
  end
end
