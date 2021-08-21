require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Spotify < OmniAuth::Strategies::OAuth2
      option :name, 'spotify'

      option :client_options, {
        site:          RSpotify::API_URI,
        authorize_url: RSpotify::AUTHORIZE_URI,
        token_url:     RSpotify::TOKEN_URI,
      }

      uid { raw_info['id'] }

      info { raw_info }

      credentials do
        hash = {"token" => access_token.token}
        hash["refresh_token"] = access_token.refresh_token if access_token.expires? && access_token.refresh_token
        hash["expires_at"] = access_token.expires_at if access_token.expires?
        hash["expires"] = access_token.expires?
        hash["scope"] = access_token['scope']
        hash
      end

      def raw_info
        @raw_info ||= access_token.get('me').parsed
      end
      
      # Fix for: https://github.com/guilhermesad/rspotify/issues/189
      def callback_url
        full_host + script_name + callback_path
      end
    end
  end
end
