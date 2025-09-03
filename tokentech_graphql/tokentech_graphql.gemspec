# frozen_string_literal: true

require_relative "lib/tokentech_graphql/version"

Gem::Specification.new do |spec|
  spec.name          = "tokentech_graphql"
  spec.version       = TokentechGraphql::VERSION
  spec.authors       = ["Gon4ar5"]
  spec.email         = ["your_email@example.com"]

  spec.summary       = "GraphQL helpers for Tokentech project"
  spec.description   = "Reusable GraphQL types, mutations, and utilities extracted from Tokentech."
  spec.license       = "MIT"

  # самое важное — починить metadata
  spec.metadata["homepage_uri"] = "https://github.com/Gon4ar5/tokentech_graphql"
  spec.metadata["source_code_uri"] = "https://github.com/Gon4ar5/tokentech_graphql"
  spec.metadata["changelog_uri"] = "https://github.com/Gon4ar5/tokentech_graphql/blob/main/CHANGELOG.md"

  spec.files = Dir["lib/**/*.rb", "README.md"]
end