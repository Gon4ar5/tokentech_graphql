# frozen_string_literal: true
require 'graphql'
require 'memoist'
require 'zeitwerk'
require 'active_support/concern'

require_relative "tokentech_graphql/version"

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect(
  "graphql" => "Graphql"
)
loader.setup

module TokentechGraphql
  class Error < StandardError; end
end
