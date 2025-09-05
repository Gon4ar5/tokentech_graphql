# frozen_string_literal: true
require 'graphql'
require 'memoist'
require 'zeitwerk'

require_relative "tokentech_graphql/version"

loader = Zeitwerk::Loader.for_gem
loader.log!
loader.inflector.inflect(
  "graphql_api" => "GraphqlApi"
)
loader.setup

module TokentechGraphql
  class Error < StandardError; end
end

module TokentechGraphql
  module GraphqlV2; end
end
