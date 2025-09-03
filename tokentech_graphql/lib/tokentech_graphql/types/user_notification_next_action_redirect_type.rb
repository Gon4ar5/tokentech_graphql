module GraphqlApi
  module Types
    class UserNotificationNextActionRedirectType < BaseType
      field :path,
            String,
            null: true,
            description: "Relative path to redirect to.\n" \
                         'Equals `null` if the redirect is external.'
      field :title, String, null: false, description: 'Action button/link text'
      field :url, String, null: false, description: 'Full redirect url'

      def title
        object['title']
      end

      def url
        object['url']
      end

      def path
        object['path']
      end
    end
  end
end
