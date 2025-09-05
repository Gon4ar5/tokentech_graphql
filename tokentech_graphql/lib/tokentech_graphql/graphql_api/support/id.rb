# frozen_string_literal: true
require 'base64'

module TokentechGraphql
  module GraphqlApi
    module Support
      class Id < Struct.new(:version, :type, :value, keyword_init: true)
        class DecodingError < ArgumentError; end

        SEPARATOR = ','

        private_class_method :new

        class << self
          def encode(id_value, gql_type)
            data = ['V1', gql_type.graphql_name, id_value]
            Base64.urlsafe_encode64(data.join(SEPARATOR), padding: false)
          end

          def decode(input_id, expected_type = nil)
            raise DecodingError, 'invalid input id' unless input_id.is_a?(String) && !input_id.strip.empty?

            begin
              decoded = Base64.urlsafe_decode64(input_id)
            rescue ArgumentError => e
              raise e unless e.message == 'invalid base64'
      
              raise DecodingError, 'invalid base64'
            end
      
            components = decoded.split(Support::Id::SEPARATOR)
            raise DecodingError, 'invalid id components count' unless components.size == 3
      
            version, type, id = components
            raise DecodingError, 'invalid id version' unless version.upcase == 'V1'
            raise DecodingError, 'invalid id type' unless type =~ /\A\w+\z/
            raise DecodingError, 'invalid id value' unless id =~ /\A[\d\w_-]+\z/

            expected_type = expected_type_name(expected_type)
            if expected_type && type != expected_type
              raise DecodingError, "unexpected id type #{type.inspect} (expected #{expected_type.inspect})"
            end

            new(version:, type:, value: id)
          end

          private

          def expected_type_name(type)
            return type if type.nil? || type.is_a?(String)
            return type.graphql_name if type.respond_to?(:graphql_name)

            type.to_s
          end
        end
      end
    end
  end
end
