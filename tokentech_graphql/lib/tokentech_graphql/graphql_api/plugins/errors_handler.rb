# frozen_string_literal: true

module TokentechGraphql
  module GraphqlApi
    module Plugins
      module ErrorsHandler
        # Pass `verbose: true` to see error details in development
        def self.use(schema_defn, verbose: false, reraise_uknown: false)
          c_verbose = verbose
          c_reraise_uknown = reraise_uknown

          schema_defn.class_eval do
            rescue_from(ActiveRecord::RecordNotFound) do |err, obj, args, ctx, field|
              extensions = { id: err.id, model: err.model } if c_verbose
              # TODO: report warning
              raise Graphql::Errors::RecordNotFound.new(extensions: extensions)
            end

            rescue_from(::Exception) do |err, obj, args, ctx, field|
              raise err if c_reraise_uknown

              # TODO:
              # - report error
              # - attach sentry error id to report back to front-end

              if c_verbose
                message = err.message
                extensions = { exception: err.class.name, backtrace: err.backtrace }
              end
              raise Graphql::Errors::InternalServerError.new(message, extensions: extensions)
            end
          end
        end
      end
    end
  end
end
