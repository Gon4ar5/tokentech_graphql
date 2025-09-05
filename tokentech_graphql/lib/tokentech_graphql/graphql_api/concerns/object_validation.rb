# frozen_string_literal: true

module TokentechGraphql
  module GraphqlApi
    module Concerns
      module ObjectValidation
        def self.included(base)
          base.extend(ClassMethods)
        end

        module ClassMethods
          attr_reader :object_validation_proc

          def object_type(*klasses)
            ensure_validation_proc_empty!
            @object_classes = klasses
            @object_validation_proc = ->(object) { @object_classes.any? { |klass| object.is_a?(klass) } }
          end

          alias object_types object_type

          def object_validation(validation_proc)
            ensure_validation_proc_empty!
            raise ArgumentError, "value is not a proc" unless validation_proc.is_a?(Proc)

            @object_validation_proc = validation_proc
          end

          private

          def ensure_validation_proc_empty!
            return unless @object_validation_proc
            raise "object validation already defined"
          end
        end

        private

        def validate_object!(object)
          return unless self.class.object_validation_proc
          return if self.class.object_validation_proc.call(object)

          raise Graphql::Support::ObjectValidationError.new(object, self.class)
        end
      end
    end
  end
end