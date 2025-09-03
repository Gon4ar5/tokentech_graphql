# frozen_string_literal: true

module GraphqlApi
  module Concerns
    module HasCurrentUser
      def current_user
        context[:current_user]
      end
    end
  end
end
